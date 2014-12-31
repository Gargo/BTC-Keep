//
//  BKDataAdapterCryptsy.m
//  BTC Keep
//
//  Created by Apple on 26.06.14.
//  
//

#import "BKDataAdapterCryptsy.h"

@implementation BKDataAdapterCryptsy

#pragma mark - BKDataAdapterPublicMethodsProtocol methods

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self class] new];
    });
    
    return _sharedInstance;
}

- (NSArray *)identifiersForEntityNamed:(NSString *)entityName {
    
    if ([entityName isEqualToString:BKCurrencyEntity]) {
        
        return @[BKKeyCryptsyPrimaryCurrencyCode, BKKeyCryptsySecondaryCurrencyCode];
    } else if ([entityName isEqualToString:BKTradePairEntity]) {
        
        return @[BKKeyCryptsyMarketID];
    } else if ([entityName isEqualToString:BKTradeEntity]) {
        
        return @[BKKeyCryptsyTradeID];
    }
    return nil;
}

- (NSArray *)fillSelectorsForEntityNamed:(NSString *)entityName {
    
    if ([entityName isEqualToString:BKCurrencyEntity]) {
        
        return [BSUtilities arrayWithSelectors:@selector(fillCurrency:withParams:), @selector(fillCurrency2:withParams:), nil];
    } else if ([entityName isEqualToString:BKTradePairEntity]) {
        
        return [BSUtilities arrayWithSelector:@selector(fillTradePair:withParams:)];
    } else if ([entityName isEqualToString:BKTradeEntity]) {
        
        return [BSUtilities arrayWithSelector:@selector(fillTrade:withParams:)];
    }
    return nil;
}

#pragma mark - Update methods

- (void)updateTrades:(NSArray *)trades tradePairID:(NSString *)tradePairID {
    
    {
        //tradePairID doesn't come in response
        NSMutableArray *tempItems = [NSMutableArray array];
        for (NSDictionary *dict in trades) {
            
            NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:dict];
            dict2[BKKeyTradePairId] = tradePairID;
            [tempItems addObject:dict2];
        }
        trades = tempItems;
    }
    
    [super updateTrades:trades];
}

#pragma mark - fill methods

- (void)fillCurrency:(BKCurrency *)currency withParams:(NSDictionary *)params {
    
    NSString *identifier = [BSUtilities safelyGetString:params forKey:BKKeyCryptsyPrimaryCurrencyCode];
    currency.identifier = identifier;
    currency.name = [BSUtilities safelyGetString:params forKey:BKKeyCryptsyPrimaryCurrencyCode];
}

- (void)fillCurrency2:(BKCurrency *)currency withParams:(NSDictionary *)params {
    
    NSString *identifier = [BSUtilities safelyGetString:params forKey:BKKeyCryptsySecondaryCurrencyCode];
    currency.identifier = identifier;
    currency.name = [BSUtilities safelyGetString:params forKey:BKKeyCryptsySecondaryCurrencyCode];
}

- (void)fillTradePair:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    tradePair.primaryCurrencyId = [BSUtilities safelyGetString:params forKey:BKKeyCryptsyPrimaryCurrencyCode];
    tradePair.secondaryCurrencyId = [BSUtilities safelyGetString:params forKey:BKKeyCryptsySecondaryCurrencyCode];
    tradePair.currencyVolume = [BSUtilities safelyGetNumber:params forKey:BKKeyCryptsyCurrentVolume];
    tradePair.identifier = [BSUtilities safelyGetString:params forKey:BKKeyCryptsyMarketID];
    tradePair.lastRate = [BSUtilities safelyGetNumber:params forKey:BKKeyCryptsyLastTrade];
    tradePair.marketVolume = tradePair.currencyVolume;
    tradePair.maxRate = [BSUtilities safelyGetNumber:params forKey:BKKeyCryptsyHighTrade];
    tradePair.minRate = [BSUtilities safelyGetNumber:params forKey:BKKeyCryptsyLowTrade];
}

- (void)fillTrade:(BKTrade *)trade withParams:(NSDictionary *)params {
    
    trade.amount = [BSUtilities safelyGetNumber:params forKey:BKKeyCryptsyTotal];
    trade.isBid = @([[BSUtilities safelyGetString:params forKey:BKKeyCryptsyInitiateOrdertype] isEqualToString:@"Buy"]);
    {
        NSString *dateString = [BSUtilities safelyGetString:params forKey:BKKeyCryptsyDateTime];
        NSDateFormatter *dateFormatter = [BSUtilities dateFormatterWithFormat:BKCommonDateFormat];
        trade.createdAt = [dateFormatter dateFromString:dateString];
    }
    trade.identifier = [BSUtilities safelyGetString:params forKey:BKKeyCryptsyTradeID];
    trade.rate = [BSUtilities safelyGetNumber:params forKey:BKKeyCryptsyTradePrice];
    trade.tradePairId = [BSUtilities safelyGetString:params forKey:BKKeyTradePairId];
    //tradepair id doesn't come
}

@end

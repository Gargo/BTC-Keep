//
//  BKDataAdapterC_Cex.m
//  BTC Keep
//
//  Created by Apple on 20.10.14.
//  
//

#import "BKDataAdapterC_Cex.h"

#define BKC_CexCurrencySeparator    @"-"

@implementation BKDataAdapterC_Cex

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self class] new];
    });
    
    return _sharedInstance;
}

- (NSArray *)identifiersForEntityNamed:(NSString *)entityName {
    
//    if ([entityName isEqualToString:BKCurrencyEntity]) {
//        
//        return nil;
//    } else if ([entityName isEqualToString:BKTradePairEntity]) {
//        
////        return nil;
//    } else if ([entityName isEqualToString:BKTradeEntity]) {
//        
////        return @[BKKeyLocalBitcoinsTID];
//    }
    return nil;
}

- (NSArray *)fillSelectorsForEntityNamed:(NSString *)entityName {
    
    if ([entityName isEqualToString:BKCurrencyEntity]) {
        
        return [BSUtilities arrayWithSelector:@selector(fillCurrency:withParams:)];
    } else if ([entityName isEqualToString:BKTradePairEntity]) {
        
        return [BSUtilities arrayWithSelector:@selector(fillTradePair:withParams:)];
    } else if ([entityName isEqualToString:BKTradeEntity]) {
        
        return [BSUtilities arrayWithSelector:@selector(fillTrade:withParams:)];
    }
    return nil;
}

#pragma mark - Update methods

- (void)updateCurrencies:(id)currencies {
    
    //to delete duplicates and create NSDictionary at once
    NSMutableDictionary *currencyIDDict = [NSMutableDictionary dictionary];
    for (NSString *currencyIDs in currencies) {
        
        NSArray *strs = [currencyIDs componentsSeparatedByString:BKC_CexCurrencySeparator];
        for (NSString *str in strs) {
            
            currencyIDDict[str] = @{};
        }
    }
    [super updateCurrencies:currencyIDDict];
}

- (void)updateTrades:(id)trades tradePairID:(NSString *)tradePairID {
    
    {
        //trade pair volume doesn't come but we can count it using trades
        double volume = 0;
        for (NSDictionary *dict in trades) {
            
            volume += [[BSUtilities safelyGetNumber:dict forKey:BKKeyC_CexAmount] doubleValue];
        }
        NSDictionary *fillParams = @{tradePairID : @{BKKeyC_CexAmount : @(volume)}};
        [dataManager updateEntitityNamed:BKTradePairEntity
                          identifierName:nil
                                  filler:self
                            fillSelector:@selector(fillTradePair2:withParams:)
                              fillParams:fillParams
                               deleteOld:NO
                             forExchange:self];
    }
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
    
//    NSArray *currencyIDs = [params.allKeys.lastObject componentsSeparatedByString:BKC_CexCurrencySeparator];
//    if (currencyIDs.count != 2) {
//        
//        return;
//    }
    currency.identifier = params.allKeys.lastObject;
    currency.name = [currency.identifier uppercaseString];
}

- (void)fillTradePair:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    NSString *currencyIDsStr = params.allKeys.lastObject;
    NSArray *currencyIDs = [currencyIDsStr componentsSeparatedByString:BKC_CexCurrencySeparator];
    if (currencyIDs.count != 2) {
        
        return;
    }
    tradePair.primaryCurrencyId = currencyIDs[0];
    tradePair.secondaryCurrencyId = currencyIDs[1];
    params = params.allValues.lastObject;
    tradePair.identifier = currencyIDsStr;
    tradePair.lastRate = [BSUtilities safelyGetNumber:params forKey:BKKeyC_CexLastTrade];
    tradePair.maxRate = [BSUtilities safelyGetNumber:params forKey:BKKeyC_CexMaxRate];
    tradePair.minRate = [BSUtilities safelyGetNumber:params forKey:BKKeyC_CexMinRate];
    
    //Volume doesn't come
//    tradePair.currencyVolume = [BSUtilities safelyGetNumber:params forKey:params.allKeys.lastObject];
//    tradePair.marketVolume = tradePair.currencyVolume;
}

- (void)fillTradePair2:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    params = params.allValues.lastObject;
    tradePair.currencyVolume = tradePair.marketVolume = params[BKKeyC_CexAmount];
}

- (void)fillTrade:(BKTrade *)trade withParams:(NSDictionary *)params {
    
    NSDateFormatter *dateFormatter = [BSUtilities dateFormatterWithFormat:BKCommonDateFormat];
    trade.createdAt = [dateFormatter dateFromString:[BSUtilities safelyGetString:params forKey:BKKeyC_CexDate]];
    trade.amount = [BSUtilities safelyGetNumber:params forKey:BKKeyC_CexAmount];
    trade.rate = [BSUtilities safelyGetNumber:params forKey:BKKeyC_CexRate];
    trade.isBid = @([[BSUtilities safelyGetString:params forKey:BKKeyC_CexIsBid] isEqualToString:@"Buy"] ? YES : NO);
    trade.tradePairId = [BSUtilities safelyGetString:params forKey:BKKeyTradePairId];
    
//    //identifier doesn't come from server
//    trade.identifier = [BSUtilities safelyGetString:params forKey:BKKeyLocalBitcoinsTID];
}

@end

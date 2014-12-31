//
//  BKDataAdapterBitstamp.m
//  BTC Keep
//
//  Created by Vyachaslav on 10.10.14.
//  
//

#import "BKDataAdapterBitstamp.h"

#define BKBitstampPrimaryCurrency   @"BTC"
#define BKBitstampSecondaryCurrency @"USD"
#define BKBItstampSingleTradePairID @"1"

@implementation BKDataAdapterBitstamp

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self class] new];
    });
    
    return _sharedInstance;
}

- (NSArray *)identifiersForEntityNamed:(NSString *)entityName {
    
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

- (void)updateCurrencies {
    
    NSArray *arr = @[@{BKKeyId : BKBitstampPrimaryCurrency}, @{BKKeyId : BKBitstampSecondaryCurrency}];
    [dataManager updateEntititesNamed:BKCurrencyEntity filler:self fillParams:arr forExchange:self];
}

- (void)updateOneTradePair:(NSDictionary *)tradePair {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:tradePair];
    dict[BKKeyId] = BKBItstampSingleTradePairID;
    dict[BKKeyPrimaryCurrencyId] = BKBitstampPrimaryCurrency;
    dict[BKKeySecondaryCurrencyId] = BKBitstampSecondaryCurrency;
    [dataManager updateEntititesNamed:BKTradePairEntity filler:self fillParams:@[dict] forExchange:self];
}

#pragma mark - fill methods

- (void)fillCurrency:(BKCurrency *)currency withParams:(NSDictionary *)params {
    
    currency.identifier = params.allValues.lastObject;
    currency.name = params.allValues.lastObject;
}

- (void)fillTradePair:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    tradePair.identifier = params[BKKeyId];
    tradePair.primaryCurrencyId = [BSUtilities safelyGetString:params forKey:BKKeyPrimaryCurrencyId];
    tradePair.secondaryCurrencyId = [BSUtilities safelyGetString:params forKey:BKKeySecondaryCurrencyId];
    tradePair.currencyVolume = [BSUtilities safelyGetNumber:params forKey:BKKeyBitstampVolume];
    tradePair.lastRate = [BSUtilities safelyGetNumber:params forKey:BKKeyBitstampLastTrade];
    tradePair.marketVolume = tradePair.currencyVolume;
    tradePair.maxRate = [BSUtilities safelyGetNumber:params forKey:BKKeyBitstampHighTrade];
    tradePair.minRate = [BSUtilities safelyGetNumber:params forKey:BKKeyBitstampLowTrade];
}

- (void)fillTrade:(BKTrade *)trade withParams:(NSDictionary *)params {
    
    trade.identifier = [BSUtilities safelyGetString:params forKey:BKKeyBitstampTransactionID];
    trade.amount = [BSUtilities safelyGetNumber:params forKey:BKKeyBitstampAmount];
    trade.createdAt = [NSDate dateWithTimeIntervalSince1970:[BSUtilities safelyGetNumber:params forKey:BKKeyBitstampDate].doubleValue];
    trade.rate = [BSUtilities safelyGetNumber:params forKey:BKKeyBitstampPrice];
    trade.tradePairId = BKBItstampSingleTradePairID;
    //isBid doesn't come from server
}

@end

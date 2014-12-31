//
//  BKDataAdapterLocalBitcoins.m
//  BTC Keep
//
//  Created by Vyachaslav on 16.10.14.
//  
//

#import "BKDataAdapterLocalBitcoins.h"

#define BKLocalBitcoinsPrimaryCurrency   @"BTC"

@implementation BKDataAdapterLocalBitcoins

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
        
        return nil;
    } else if ([entityName isEqualToString:BKTradePairEntity]) {
        
        return nil;
    } else if ([entityName isEqualToString:BKTradeEntity]) {
        
        return @[BKKeyLocalBitcoinsTID];
    }
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
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:currencies];
    dict[BKLocalBitcoinsPrimaryCurrency] = @{};
    [super updateCurrencies:dict];
}

- (void)updateTrades:(NSArray *)trades tradePairID:(NSString *)tradePairID {
    
    {
        double minRate, maxRate;
        minRate = maxRate = [[BSUtilities safelyGetNumber:trades.lastObject forKey:BKKeyLocalBitcoinsRate] doubleValue];
        //LocalBitcoins doesn't have max/min rate params so we should find them manually
        for (NSDictionary *dict in trades) {
            
            double rate = [[BSUtilities safelyGetNumber:dict forKey:BKKeyLocalBitcoinsRate] doubleValue];
            if (minRate > rate) {
                
                minRate = rate;
            } else if (maxRate < rate) {
                
                maxRate = rate;
            }
        }
        NSDictionary *fillParams = @{tradePairID : @{BKKeyLocalBitcoinsMinRate : @(minRate), BKKeyLocalBitcoinsMaxRate : @(maxRate)}};
        [dataManager updateEntitityNamed:BKTradePairEntity
                          identifierName:BKKeyLocalBitcoinsTID
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
    
    currency.identifier = currency.name = params.allKeys.lastObject;
}

- (void)fillTradePair:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    tradePair.primaryCurrencyId = BKLocalBitcoinsPrimaryCurrency;
    tradePair.secondaryCurrencyId = params.allKeys.lastObject;
    params = params.allValues.lastObject;
    tradePair.currencyVolume = [BSUtilities safelyGetNumber:params forKey:params.allKeys.lastObject];
    tradePair.identifier = tradePair.secondaryCurrencyId;
    params = params[BKKeyLocalBitcoinsRates];
    tradePair.lastRate = [BSUtilities safelyGetNumber:params forKey:BKKeyLocalBitcoinsLastTrade];
    tradePair.marketVolume = tradePair.currencyVolume;
    
//    //max and min don't come
//    tradePair.maxRate = [BSUtilities safelyGetNumber:params forKey:BKKeyCryptsyHighTrade];
//    tradePair.minRate = [BSUtilities safelyGetNumber:params forKey:BKKeyCryptsyLowTrade];
}

- (void)fillTradePair2:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    params = params.allValues.lastObject;
    tradePair.minRate = params[BKKeyLocalBitcoinsMinRate];
    tradePair.maxRate = params[BKKeyLocalBitcoinsMaxRate];
}

- (void)fillTrade:(BKTrade *)trade withParams:(NSDictionary *)params {
    
    trade.identifier = [BSUtilities safelyGetString:params forKey:BKKeyLocalBitcoinsTID];
    trade.amount = [BSUtilities safelyGetNumber:params forKey:BKKeyLocalBitcoinsAmount];
    trade.createdAt = [NSDate dateWithTimeIntervalSince1970:[BSUtilities safelyGetNumber:params forKey:BKKeyLocalBitcoinsDate].doubleValue];
    trade.rate = [BSUtilities safelyGetNumber:params forKey:BKKeyLocalBitcoinsRate];
    trade.tradePairId = [BSUtilities safelyGetString:params forKey:BKKeyTradePairId];
    //isBid doesn't come from server
}

@end

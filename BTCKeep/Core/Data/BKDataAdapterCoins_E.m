//
//  BKDataAdapterCoins_e.m
//  BTC Keep
//
//  Created by Vyachaslav on 06.08.14.
//  
//

#import "BKDataAdapterCoins_E.h"

@implementation BKDataAdapterCoins_E

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
        
        return @[BKKeyCoins_EPrimaryCurrencyCode, BKKeyCoins_ESecondaryCurrencyCode];
    } else if ([entityName isEqualToString:BKTradePairEntity]) {
        
        return nil;
    } else if ([entityName isEqualToString:BKTradeEntity]) {
        
        return @[BKKeyCoins_EID];
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

//- (void)updateTrades:(NSArray *)trades tradePairID:(NSString *)tradePairID {
//    
//    {
//        //tradePairID doesn't come in response
//        NSMutableArray *tempItems = [NSMutableArray array];
//        for (NSDictionary *dict in trades) {
//            
//            NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:dict];
//            dict2[BKKeyTradePairId] = tradePairID;
//            [tempItems addObject:dict2];
//        }
//        trades = tempItems;
//    }
//    
//    [super updateTrades:trades];
//}

#pragma mark - fill methods

- (void)fillCurrency:(BKCurrency *)currency withParams:(NSDictionary *)params {
    
    params = params[params.allKeys.lastObject];
    currency.identifier = [BSUtilities safelyGetString:params forKey:BKKeyCoins_EPrimaryCurrencyCode];
    currency.name = [BSUtilities safelyGetString:params forKey:BKKeyCoins_EPrimaryCurrencyCode];
}

- (void)fillCurrency2:(BKCurrency *)currency withParams:(NSDictionary *)params {
    
    params = params[params.allKeys.lastObject];
    currency.identifier = [BSUtilities safelyGetString:params forKey:BKKeyCoins_ESecondaryCurrencyCode];
    currency.name = [BSUtilities safelyGetString:params forKey:BKKeyCoins_ESecondaryCurrencyCode];
}

- (void)fillTradePair:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    tradePair.identifier = [params allKeys].lastObject;
    
    params = params[tradePair.identifier];
    tradePair.primaryCurrencyId = [BSUtilities safelyGetString:params forKey:BKKeyCoins_EPrimaryCurrencyCode];
    tradePair.secondaryCurrencyId = [BSUtilities safelyGetString:params forKey:BKKeyCoins_ESecondaryCurrencyCode];
    
    params = params[BKKeyCoins_EMarketStat];
    {
        NSNumber *askNumber = [BSUtilities safelyGetNumber:params forKey:BKKeyCoins_ECurrentVolumeAsk];
        NSNumber *bidNumber = [BSUtilities safelyGetNumber:params forKey:BKKeyCoins_ECurrentVolumeBid];
        tradePair.currencyVolume = @(askNumber.doubleValue + bidNumber.doubleValue);
    }
    tradePair.lastRate = [BSUtilities safelyGetNumber:params forKey:BKKeyCoins_ELastTrade];
    tradePair.marketVolume = tradePair.currencyVolume;
    tradePair.maxRate = [BSUtilities safelyGetNumber:params forKey:BKKeyCoins_EHighTrade];
    tradePair.minRate = [BSUtilities safelyGetNumber:params forKey:BKKeyCoins_ELowTrade];
}

- (void)fillTrade:(BKTrade *)trade withParams:(NSDictionary *)params {
    
    trade.identifier = [BSUtilities safelyGetString:params forKey:BKKeyCoins_EID];
    trade.amount = [BSUtilities safelyGetNumber:params forKey:BKKeyCoins_EQuantity];
    trade.createdAt = [NSDate dateWithTimeIntervalSince1970:[BSUtilities safelyGetNumber:params forKey:BKKeyCoins_ECreated].doubleValue];
    trade.rate = [BSUtilities safelyGetNumber:params forKey:BKKeyCoins_ETradeRate];
    trade.tradePairId = [BSUtilities safelyGetString:params forKey:BKKeyCoins_EPairID];
    //isBid doesn't come from server
}

@end

//
//  BKDataAdapterBter.m
//  BTC Keep
//
//  Created by Apple on 04.11.14.
//  
//

#import "BKDataAdapterBter.h"

#define BKC_CexCurrencySeparator    @"_"

@implementation BKDataAdapterBter

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

        return @[BKKeyBterCurrency1, BKKeyBterCurrency2];
    } else if ([entityName isEqualToString:BKTradePairEntity]) {

        return nil;
    } else if ([entityName isEqualToString:BKTradeEntity]) {

        return @[BKKeyBterTradeID];
    }
    return nil;
}

- (NSArray *)fillSelectorsForEntityNamed:(NSString *)entityName {
    
    if ([entityName isEqualToString:BKCurrencyEntity]) {
        
        return [BSUtilities arrayWithSelectors:
                @selector(fillCurrency:withParams:),
                @selector(fillCurrency2:withParams:),
                nil];
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
    
    currency.identifier = params[BKKeyBterCurrency1];
    currency.name = params[BKKeyBterCurrency1];
}

- (void)fillCurrency2:(BKCurrency *)currency withParams:(NSDictionary *)params {
    
    //http://data.bter.com/api/1/markelist
    currency.identifier = params[BKKeyBterCurrency2];
    currency.name = params[BKKeyBterCurrency2];
}

- (void)fillTradePair:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    //http://data.bter.com/api/1/tickers
    NSString *currencyIDsStr = params.allKeys.lastObject;
    NSArray *currencyIDs = [currencyIDsStr componentsSeparatedByString:BKC_CexCurrencySeparator];
    if (currencyIDs.count != 2) {
        
        return;
    }
    tradePair.primaryCurrencyId = [currencyIDs[0] uppercaseString];
    tradePair.secondaryCurrencyId = [currencyIDs[1] uppercaseString];
    params = params.allValues.lastObject;
    tradePair.identifier = currencyIDsStr;
    tradePair.lastRate = [BSUtilities safelyGetNumber:params forKey:BKKeyBterLastTrade];
    tradePair.maxRate = [BSUtilities safelyGetNumber:params forKey:BKKeyBterMaxRate];
    tradePair.minRate = [BSUtilities safelyGetNumber:params forKey:BKKeyBterMinRate];
    tradePair.currencyVolume = [BSUtilities safelyGetNumber:params forKey:BKKeyBterBTCQuantity];
    tradePair.marketVolume = [BSUtilities safelyGetNumber:params forKey:BKKeyBterBTCQuantity];
}

- (void)fillTrade:(BKTrade *)trade withParams:(NSDictionary *)params {
    
    //http://data.bter.com/api/1/trade/btc_cny
    trade.createdAt = [NSDate dateWithTimeIntervalSince1970:[[BSUtilities safelyGetNumber:params forKey:BKKeyBterDate] doubleValue]];
    trade.amount = [BSUtilities safelyGetNumber:params forKey:BKKeyBterAmount];
    trade.rate = [BSUtilities safelyGetNumber:params forKey:BKKeyBterRate];
    trade.isBid = @([[BSUtilities safelyGetString:params forKey:BKKeyBterType] isEqualToString:@"buy"] ? YES : NO);
    trade.tradePairId = [BSUtilities safelyGetString:params forKey:BKKeyTradePairId];
    trade.identifier = [BSUtilities safelyGetString:params forKey:BKKeyBterTradeID];
}

@end

//
//  BKDataAdapterBitstamp.h
//  BTC Keep
//
//  Created by Vyachaslav on 10.10.14.
//  
//

#import "BKDataAdapter.h"

#define BKKeyBitstampVolume         @"volume"
#define BKKeyBitstampLastTrade      @"last"
#define BKKeyBitstampHighTrade      @"high"
#define BKKeyBitstampLowTrade       @"low"
#define BKKeyBitstampAmount         @"amount"
#define BKKeyBitstampTransactionID  @"tid"
#define BKKeyBitstampDate           @"date"
#define BKKeyBitstampPrice          @"price"

@interface BKDataAdapterBitstamp : BKDataAdapter

- (void)updateCurrencies;
- (void)updateOneTradePair:(NSDictionary *)tradePair;

@end

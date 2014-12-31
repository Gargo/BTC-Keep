//
//  BKDataAdapterBter.h
//  BTC Keep
//
//  Created by Apple on 04.11.14.
//  
//

#import "BKDataAdapter.h"

#define BKKeyBterCurrency1      @"curr_a"
#define BKKeyBterCurrency2      @"curr_b"
#define BKKeyBterTradePairID    @"pair"
#define BKKeyBterLastTrade      @"last"
#define BKKeyBterMinRate        @"low"
#define BKKeyBterMaxRate        @"high"
#define BKKeyBterBTCQuantity    @"vol_btc"
#define BKKeyBterDate           @"date"
#define BKKeyBterAmount         @"amount"
#define BKKeyBterRate           @"price"
#define BKKeyBterType           @"type"
#define BKKeyBterTradeID        @"tid"

@interface BKDataAdapterBter : BKDataAdapter

@end

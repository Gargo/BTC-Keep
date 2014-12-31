//
//  BKDataAdapterC_Cex.h
//  BTC Keep
//
//  Created by Apple on 20.10.14.
//  
//

#import "BKDataAdapter.h"

#define BKKeyC_CexLastTrade @"lastprice"
#define BKKeyC_CexMinRate   @"low"
#define BKKeyC_CexMaxRate   @"high"
#define BKKeyC_CexDate      @"datetime"
#define BKKeyC_CexAmount    @"amount"
#define BKKeyC_CexRate      @"rate"
#define BKKeyC_CexIsBid     @"type"

@interface BKDataAdapterC_Cex : BKDataAdapter

@end

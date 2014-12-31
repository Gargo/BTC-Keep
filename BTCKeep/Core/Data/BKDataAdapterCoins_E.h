//
//  BKDataAdapterCoins_e.h
//  BTC Keep
//
//  Created by Vyachaslav on 06.08.14.
//  
//

#import "BKDataAdapter.h"

#define BKKeyCoins_EPrimaryCurrencyCode     @"c1"
#define BKKeyCoins_EPrimaryCurrencyName     @"coin1"
#define BKKeyCoins_ESecondaryCurrencyCode   @"c2"
#define BKKeyCoins_ECurrentVolumeAsk        @"total_bid_q"
#define BKKeyCoins_ECurrentVolumeBid        @"total_ask_q"
#define BKKeyCoins_ELastTrade               @"ltp"
#define BKKeyCoins_EHighTrade               @"ask"
#define BKKeyCoins_ELowTrade                @"bid"
#define BKKeyCoins_EQuantity                @"quantity"
#define BKKeyCoins_ECreated                 @"created"
#define BKKeyCoins_EID                      @"id"
#define BKKeyCoins_ETradeRate               @"rate"
#define BKKeyCoins_EPairID                  @"pair"
#define BKKeyCoins_EMarkets                 @"markets"
#define BKKeyCoins_EMarketStat              @"marketstat"
#define BKKeyCoins_ETrades                  @"trades"

@interface BKDataAdapterCoins_E : BKDataAdapter

@end

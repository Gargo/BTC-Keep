//
//  BKDataAdapterCryptsy.h
//  BTC Keep
//
//  Created by Apple on 26.06.14.
//  
//

#import "BKDataAdapter.h"

#define BKKeyCryptsyPrimaryCurrencyCode     @"primary_currency_code"
#define BKKeyCryptsyPrimaryCurrencyName     @"primary_currency_name"
#define BKKeyCryptsySecondaryCurrencyCode   @"secondary_currency_code"
#define BKKeyCryptsySecondaryCurrencyName   @"secondary_currency_name"
#define BKKeyCryptsyCurrentVolume           @"current_volume"
#define BKKeyCryptsyMarketID                @"marketid"
#define BKKeyCryptsyLastTrade               @"last_trade"
#define BKKeyCryptsyHighTrade               @"high_trade"
#define BKKeyCryptsyLowTrade                @"low_trade"

#define BKKeyCryptsyTotal                   @"total"
#define BKKeyCryptsyQuantity                @"quantity"
#define BKKeyCryptsyInitiateOrdertype       @"\"initiate_ordertype\""
#define BKKeyCryptsyDateTime                @"datetime"
#define BKKeyCryptsyTradeID                 @"tradeid"
#define BKKeyCryptsyTradePrice              @"tradeprice"
#define BKKeyCryptsySuccess                 @"success"

//Custom keys
#define BKKeyCryptsyException               @"exception"

@interface BKDataAdapterCryptsy : BKDataAdapter

@end

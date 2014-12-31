//
//  BKDataAdapterLocalBitcoins.h
//  BTC Keep
//
//  Created by Vyachaslav on 16.10.14.
//  
//

#import "BKDataAdapter.h"

#define BKKeyLocalBitcoinsCurrencyVolume    @"volume_btc"
#define BKKeyLocalBitcoinsRates             @"rates"
#define BKKeyLocalBitcoinsLastTrade         @"last"
#define BKKeyLocalBitcoinsTID               @"tid"
#define BKKeyLocalBitcoinsDate              @"date"
#define BKKeyLocalBitcoinsAmount            @"amount"
#define BKKeyLocalBitcoinsRate              @"price"
#define BKKeyLocalBitcoinsMinRate           @"minRate"
#define BKKeyLocalBitcoinsMaxRate           @"maxRate"

@interface BKDataAdapterLocalBitcoins : BKDataAdapter

@end

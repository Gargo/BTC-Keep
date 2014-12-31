//
//  BKNetworkManagerLocalBitcoins.m
//  BTC Keep
//
//  Created by Vyachaslav on 16.10.14.
//  
//

#import "BKNetworkManagerLocalBitcoins.h"
#import "BKDataAdapterLocalBitcoins.h"
#import "SVProgressHUD.h"

#define BKURLLocalBitcoinsGetCurrencies         @"https://localbitcoins.com/bitcoinaverage/ticker-all-currencies/"
#define BKURLLocalBitcoinsGetTradesForCurrency  @"https://localbitcoins.com/bitcoincharts/%@/trades.json"
#define BKURLLocalBitcoinsGetOrdersForCurrency  @"https://localbitcoins.com/bitcoincharts/%@/orderbook.json"

//trade pairs and currencies have the same id

@implementation BKNetworkManagerLocalBitcoins

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[[self class] alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init {
    
    if ((self = [super initWithBlock:^{
        
        self.exchangeName = @"LocalBitcoins";
    }])) {
        
    }
    return self;
}

#pragma mark - public request methods

- (void)requestTradePairs {
    
    BKVoidBlockFromIDObject b = ^(id items) {
        
        [[BKDataAdapterLocalBitcoins sharedInstance] updateCurrencies:items];
        [[BKDataAdapterLocalBitcoins sharedInstance] updateTradePairs:items];
    };
    [self runOperationBySendingGETRequests:@[BKURLLocalBitcoinsGetCurrencies]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradePairs
                             successBLocks:@[b]
                             failureBlocks:nil];
}

- (void)requestTradesForTradePairID:(NSString *)tradePairID {
    
    BKVoidBlockFromIDObject b = ^(id items) {
        
        [[BKDataAdapterLocalBitcoins sharedInstance] updateTrades:items tradePairID:tradePairID];
    };
    NSString *URLString = [NSString stringWithFormat:BKURLLocalBitcoinsGetTradesForCurrency, tradePairID];
    [self runOperationBySendingGETRequests:@[URLString]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradesForTradePair
                             successBLocks:@[b]
                             failureBlocks:nil];
}

@end

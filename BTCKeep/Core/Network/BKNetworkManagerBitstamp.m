//
//  BKNetworkManagerBitstamp.m
//  BTC Keep
//
//  Created by Apple on 10.10.14.
//  
//

#import "BKNetworkManagerBitstamp.h"
#import "BKDataAdapterBitstamp.h"
#import "SVProgressHUD.h"

//more API possibilities require passport data
#define BKURLBitstampGetTicker                  @"https://www.bitstamp.net/api/ticker/"
#define BKURLBitstampGetOrderbook               @"https://www.bitstamp.net/api/order_book/"
#define BKURLBitstampGetTransactions            @"https://www.bitstamp.net/api/transactions/"
#define BKURLBitstampGetEUR_USDConversionRate   @"https://www.bitstamp.net/api/eur_usd/"

@implementation BKNetworkManagerBitstamp

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
        
        self.exchangeName = @"BitStamp";
    }])) {
        
    }
    return self;
}

#pragma mark - public request methods

- (void)requestTradePairs {
    
    BKVoidBlockFromIDObject b = ^(id obj) {
        
        [[BKDataAdapterBitstamp sharedInstance] updateCurrencies];
        [[BKDataAdapterBitstamp sharedInstance] updateOneTradePair:obj];
    };
    [self runOperationBySendingGETRequests:@[BKURLBitstampGetTicker]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradePairs
                             successBLocks:@[b]
                             failureBlocks:nil];
}

- (void)requestTradesForTradePairID:(NSString *)tradePairID {
    
    BKVoidBlockFromIDObject b = ^(id obj) {
        
        [[BKDataAdapterBitstamp sharedInstance] updateTrades:obj];
    };
    [self runOperationBySendingGETRequests:@[BKURLBitstampGetTransactions]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradesForTradePair
                             successBLocks:@[b]
                             failureBlocks:nil];
}

@end

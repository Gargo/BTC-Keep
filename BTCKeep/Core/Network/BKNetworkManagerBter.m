//
//  BKNetworkManagerBter.m
//  BTC Keep
//
//  Created by Apple on 06.11.14.
//  
//

#import "BKNetworkManagerBter.h"
#import "BKDataAdapterBter.h"
#import "SVProgressHUD.h"

#define BKKeyBterData   @"data"

#define BKURLBterGetTradePairs              @"http://data.bter.com/api/1/pairs"
#define BKURLBterGetMarketInfo              @"http://data.bter.com/api/1/marketinfo"
#define BKURLBterGetDetailedMarketInfo      @"http://data.bter.com/api/1/marketlist"
#define BKURLBterGetTickers                 @"http://data.bter.com/api/1/tickers"
#define BKURLBterGetTickerForTradePairID    @"http://data.bter.com/api/1/ticker/%@"
#define BKURLBterGetOrdersForTradePairID    @"http://data.bter.com/api/1/depth/%@"
#define BKURLBterGetTradesForTradePairID    @"http://data.bter.com/api/1/trade/%@"
#define BKURLBterGetTradesAfterTradeID      @"http://data.bter.com/api/1/trade/%@/%@"
#define BKURLBterGetBalances                @"https://bter.com/api/1/private/getfunds"
#define BKURLBterCreateOrder                @"https://bter.com/api/1/private/placeorder"
#define BKURLBterCancelOrder                @"https://bter.com/api/1/private/cancelorder"
#define BKURLBterGetMyOrderInfo             @"https://bter.com/api/1/private/getorder"
#define BKURLBterGetMyOrderList             @"https://bter.com/api/1/private/orderlist"
#define BKURLBterGetMyLast24Trades          @"https://bter.com/api/1/private/mytrades"

@implementation BKNetworkManagerBter

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
        
        self.exchangeName = @"Bter";
    }])) {
        
    }
    return self;
}

#pragma mark - public request methods

- (void)requestTradePairs {
    
    BKVoidBlockFromIDObject b = ^(id items) {
        
        [[BKDataAdapterBter sharedInstance] updateCurrencies:items[BKKeyBterData]];
    };
    BKVoidBlockFromIDObject b2 = ^(id items) {
        
        [[BKDataAdapterBter sharedInstance] updateTradePairs:items];
    };
    [self runOperationBySendingGETRequests:@[BKURLBterGetDetailedMarketInfo, BKURLBterGetTickers]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradePairs
                             successBLocks:@[b, b2]
                             failureBlocks:nil];
}

- (void)requestTradesForTradePairID:(NSString *)tradePairID {
    
    BKVoidBlockFromIDObject b = ^(id items) {
        
        [[BKDataAdapterBter sharedInstance] updateTrades:items[BKKeyBterData] tradePairID:tradePairID];
    };
    [self runOperationBySendingGETRequests:@[[NSString stringWithFormat:BKURLBterGetTradesForTradePairID, tradePairID]]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradesForTradePair
                             successBLocks:@[b]
                             failureBlocks:nil];
}

@end

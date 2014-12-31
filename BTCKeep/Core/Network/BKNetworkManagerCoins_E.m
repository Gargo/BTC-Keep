//
//  BKNetworkManagerCoins_E.m
//  BTC Keep
//
//  Created by Vyachaslav on 06.08.14.
//  
//

#import "BKNetworkManagerCoins_E.h"
#import "BKDataAdapterCoins_E.h"
#import "SVProgressHUD.h"

//markets
#define BKURLCoins_EGetMarketList               @"https://www.coins-e.com/api/v2/markets/list/"
#define BKURLCoins_EGetCoinList                 @"https://www.coins-e.com/api/v2/coins/list/"
#define BKURLCoins_EGetConsolidatedMarketData   @"https://www.coins-e.com/api/v2/markets/data/"
#define BKURLCoins_EGetOpenOrders               @"https://www.coins-e.com/api/v2/market/%@/depth/"
#define BKURLCoins_EGetRecentTrades             @"https://www.coins-e.com/api/v2/market/%@/trades/"

//wallets
#define BKURLCoins_EGetAllWallets               @"https://www.coins-e.com/api/v2/wallet/all/"
#define BKURLCoins_EGetWallet                   @"https://www.coins-e.com/api/v2/wallet/%@/"
#define BKURLCoins_EGetDepositAddress           @"https://www.coins-e.com/api/v2/wallet/%@/"
#define BKURLCoins_EUpdateWallet                @"https://www.coins-e.com/api/v2/wallet/%@/"

//orders
#define BKURLCoins_ECreateNewOrder              @"https://www.coins-e.com/api/v2/market/%@/"
#define BKURLCoins_EGetOrder                    @"https://www.coins-e.com/api/v2/market/%@/"
#define BKURLCoins_ECancelOrder                 @"https://www.coins-e.com/api/v2/market/%@/"
#define BKURLCoins_EGetOrderList                @"https://www.coins-e.com/api/v2/market/%@/"

#define BKKeyMethod         @"method"
#define BKKeyNonce          @"nonce"

@implementation BKNetworkManagerCoins_E

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
        
        self.exchangeName = @"Coins-E";
        self.linkToExchangeSettings = @"https://www.coins-e.com/exchange/api/access/";
        self.refLink = @"https://www.coins-e.com/?ref=5216291434528768";
    }])) {
        
    }
    return self;
}

#pragma mark - public request methods

- (void)requestTradePairs {
    
    BKVoidBlockFromIDObject b = ^(id obj) {
        
        NSDictionary *items = [BSUtilities safelyGetDictionary:obj forKey:BKKeyCoins_EMarkets];
        [[BKDataAdapterCoins_E sharedInstance] updateCurrencies:items];
        [[BKDataAdapterCoins_E sharedInstance] updateTradePairs:items];
    };
    [self runOperationBySendingGETRequests:@[BKURLCoins_EGetConsolidatedMarketData]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradePairs
                             successBLocks:@[b]
                             failureBlocks:nil];
}

- (void)requestTradesForTradePairID:(NSString *)tradePairID {
    
    BKVoidBlockFromIDObject b = ^(id obj) {
        
        NSArray *items = [BSUtilities safelyGetArray:obj forKey:BKKeyCoins_ETrades];
        [[BKDataAdapterCoins_E sharedInstance] updateTrades:items];
    };
    NSString *URLString = [NSString stringWithFormat:BKURLCoins_EGetRecentTrades, tradePairID];
    [self runOperationBySendingGETRequests:@[URLString]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradesForTradePair
                             successBLocks:@[b]
                             failureBlocks:nil];
}

@end

//
//  BKNetworkManagerCryptsy.m
//  BTC Keep
//
//  Created by Apple on 23.06.14.
//  
//

#import "BKNetworkManagerCryptsy.h"
#import <objc/message.h>
#import "BKDataAdapterCryptsy.h"
#import "SVProgressHUD.h"

//Get methods
//WARNING. These get methods work too slow. Use them in case of emergency only!
#define BKURLCryptsyGetAllMarketData             @"http://pubapi.cryptsy.com/api.php?method=marketdatav2" //Total market data, including last prices
#define BKURLCryptsyGetMarketDataForMarketID     @"http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid="
#define BKURLCryptsyGetAllOrderbookData          @"http://pubapi.cryptsy.com/api.php?method=orderdatav2" //Shorted market data
#define BKURLCryptsyGetOrderbookDataForMarketID  @"http://pubapi.cryptsy.com/api.php?method=singleorderdata&marketid="

//Post methods, which require keys
#define BKURLCryptsyGetMyBalances                @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetActiveMarketsData         @"https://api.cryptsy.com/api" //Get most common info about markets
#define BKURLCryptsyGetWalletStatuses            @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetMyTransactions            @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetTradesForMarketID         @"https://api.cryptsy.com/api" //All market trades
#define BKURLCryptsyGetOrdersForMarketID         @"https://api.cryptsy.com/api" //Get market short orders' info
#define BKURLCryptsyGetMyTradesForMarketID       @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetAllMyTrades               @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetMyOrdersForMarketID       @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetDepthOrdersForMarketID    @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetAllMyOrders               @"https://api.cryptsy.com/api"
#define BKURLCryptsyCreateOrderForMarketID       @"https://api.cryptsy.com/api"
#define BKURLCryptsyCancelOrderWithOrderID       @"https://api.cryptsy.com/api"
#define BKURLCryptsyCancelOrdersForMarketID      @"https://api.cryptsy.com/api"
#define BKURLCryptsyCancelAllOrders              @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetFee                       @"https://api.cryptsy.com/api"
#define BKURLCryptsyGetMyTransfers               @"https://api.cryptsy.com/api"

#define BKKeyMethod         @"method"
#define BKKeyNonce          @"nonce"

#define BKKeyReturn         @"return"

@implementation BKNetworkManagerCryptsy

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
        
        self.exchangeName = @"Cryptsy";
        self.demoPublicKey = @"6970abcd32facfeeb2c800be1ee65bdd3a333b55";
        self.demoPrivateKey = @"ef0267659474a3455f620820290d12c7ee957b8fce6e0efb349d222a3542363b0e100f745ef16347";
        self.linkToExchangeSettings = @"https://www.cryptsy.com/users/settings";
        self.refLink = @"https://www.cryptsy.com/users/register?refid=215296";
    }])) {
        
    }
    return self;
}

#pragma mark - public request methods

- (void)requestTradePairs {
    
    BKVoidBlockFromIDObject b = ^(id obj) {
        
        NSArray *items = [BSUtilities safelyGetArray:obj forKey:BKKeyReturn];
        [[BKDataAdapterCryptsy sharedInstance] updateCurrencies:items];
        [[BKDataAdapterCryptsy sharedInstance] updateTradePairs:items];
    };
    NSDictionary *params = @{BKKeyMethod : @"getmarkets", BKKeyNonce : [self incrementalParam]};
    [self runOperationBySendingSecurePOSTRequest:BKURLCryptsyGetActiveMarketsData
                                          params:params
                                notificationName:BKNotificationGotTradePairs
                                    successBLock:b
                                    failureBlock:nil];
}

- (void)requestTradesForTradePairID:(NSString *)tradePairID {
    
    BKVoidBlockFromIDObject b = ^(id obj) {
        
        NSArray *items = [BSUtilities safelyGetArray:obj forKey:BKKeyReturn];
        [[BKDataAdapterCryptsy sharedInstance] updateTrades:items tradePairID:tradePairID];
    };
    NSDictionary *params = @{BKKeyCryptsyMarketID : tradePairID, BKKeyMethod : @"markettrades", BKKeyNonce : [self incrementalParam]};
    [self runOperationBySendingSecurePOSTRequest:BKURLCryptsyGetTradesForMarketID
                                          params:params
                                notificationName:BKNotificationGotTradesForTradePair
                                    successBLock:b
                                    failureBlock:nil];
}

#pragma mark - Base requests

- (void)runOperationBySendingSecurePOSTRequest:(NSString *)URLString
                                        params:(id)params
                              notificationName:(NSString *)notificationName                                                   successBLock:(BKVoidBlockFromIDObject)successBlock                                                   failureBlock:(BKVoidBlockFromIDObject)failureBlock {
    
    __block NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:params error:nil];
        request.timeoutInterval = BKTimeoutInterval;
        NSString *paramStr = [BSUtilities requestStringFromParams:params];
        
        NSString *currentPublicKey, *currentPrivateKey;
        if (self.useDemoKey) {
            
            currentPublicKey = self.demoPublicKey;
            currentPrivateKey = self.demoPrivateKey;
        } else {
            
            currentPublicKey = self.publicKey;
            currentPrivateKey = self.privateKey;
        }
        
        [request setValue:currentPublicKey forHTTPHeaderField:@"Key"];
        [request setValue:[BSUtilities sha512:paramStr withSalt:currentPrivateKey] forHTTPHeaderField:@"Sign"];
        
        NSURLResponse *response = nil;
        NSError *err = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        if (err) {
            
            if (failureBlock) {
                
                dispatch_sync([BSUtilities mainQueue], ^{
                    
                    [SVProgressHUD show];
                });
                ((BKVoidBlock)failureBlock)();
                dispatch_sync([BSUtilities mainQueue], ^{
                    
                    [SVProgressHUD popActivity];
                });
            }
            return;
        }
        id obj = [NSDictionary dictionaryWithJsonData:data];
        if (!obj) {
            
            obj = [NSArray arrayWithJsonData:data];
        }
        dispatch_sync([BSUtilities mainQueue], ^{
            
            [SVProgressHUD show];
        });
        successBlock(obj);
        dispatch_sync([BSUtilities mainQueue], ^{
            
            [SVProgressHUD popActivity];
        });
        [BSUtilities sendNetworkNotificationNamed:notificationName isSuccessful:YES];
    }];
    [self.commonQueue addOperation:op withIdentifier:[BSUtilities operationIdentifierWithURLString:URLString params:params]];
}

@end

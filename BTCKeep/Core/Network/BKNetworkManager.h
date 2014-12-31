//
//  BKNetworkManager.h
//  BTCKeep
//
//  Created by Iryna on 5/5/14.
//  
//

#import <Foundation/Foundation.h>

#import "AFHTTPRequestOperationManager.h"
#import "BKNetworkConstants.h"
#import "BSUtilities.h"
#import "BKDistinctOperationQueue.h"

#define BKNotificationGotTradePairs         @"got trade pairs"
#define BKNotificationGotTradesForTradePair @"got trades for trade pair"

typedef void (^BKRequestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^BKRequestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

// Request ids
typedef enum {
    
    BKRequestTypeGetCurrencies,
    BKRequestTypeGetTradePairs,
    BKRequestTypeGetOrders,
    BKRequestTypeGetTrades,
    BKRequestTypeSubmitOrder,
    BKRequestTypeGetOrderStatus,
    BKRequestTypeCancelOrder,
    BKRequestTypeGetOpenedOrders,
    BKRequestTypeGetBalances
} BKRequestType;

// Request block ids
typedef enum {
    
    BKRequestBlockTypeNone,
    BKRequestBlockTypeGetAllInfo
} BKRequestBlockType;

typedef void (^BKRequestBlock)(BKRequestType requestType, BKRequestBlockType requestBlockType, NSError *error, int completionPercent);

typedef enum {
    
    BKResponseNotificationTradePairs,
    BKResponseNotificationTradePairsFailed
} BKResponseNotification;

@class BKDataManager;

@protocol BKNetworkManagetPublicMethodsProtocol

+ (instancetype)sharedInstance;

@optional
- (void)requestTradePairs;
- (void)requestTradesForTradePairID:(NSString *)tradePairID;

@end

@interface BKNetworkManager : AFHTTPRequestOperationManager <BKNetworkManagetPublicMethodsProtocol>

@property (strong, readonly, getter = commonQueue) BKDistinctOperationQueue *commonQueue;

//keys
@property (nonatomic, strong) NSString *demoPublicKey;
@property (nonatomic, strong) NSString *demoPrivateKey;
@property (nonatomic, strong, setter = setPublicKey:, getter = publicKey) NSString *publicKey;
@property (nonatomic, strong, setter = setPrivateKey:, getter = privateKey) NSString *privateKey;
@property (assign, setter = setUseDemoKey:, getter = useDemoKey) BOOL useDemoKey;

//exchange info
@property (nonatomic, strong) NSString *exchangeName;
@property (nonatomic, strong) NSString *linkToExchangeSettings;
@property (nonatomic, strong) NSString *refLink;

+ (void)setCommonQueue:(BKDistinctOperationQueue *)commonQueue;
+ (BKDistinctOperationQueue *)commonQueue;

- (id)initWithBlock:(BKVoidBlock)block;

- (void)runOperationBySendingGETRequests:(NSArray *)URLStrings
                           arrayOfParams:(NSArray *)arrayOfparams
                        notificationName:(NSString *)notificationName
                           successBLocks:(NSArray *)successBlocks
                           failureBlocks:(NSArray *)failureBlocks;
- (id)incrementalParam;

@end

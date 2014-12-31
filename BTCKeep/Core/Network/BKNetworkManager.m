//
//  BKNetworkManager.m
//  BTCKeep
//
//  Created by Iryna on 5/5/14.
//  
//

#import "BKNetworkManager.h"
#import "BKSettingsManager.h"
#import "SVProgressHUD.h"

static BKDistinctOperationQueue *theCommonQueue = nil;

@interface BKNetworkManager()

@property (setter = setCommonQueue:, getter = commonQueue) BKDistinctOperationQueue *commonQueue;

@end

@implementation BKNetworkManager

@synthesize commonQueue;

- (id)initWithBlock:(BKVoidBlock)block {
    
    if ((self = [super init])) {
        
        self.commonQueue = [[BKDistinctOperationQueue alloc] init];
        commonQueue.maxConcurrentOperationCount = 1;
        
        block();
        
        if (!self.publicKey && self.demoPublicKey) {
            
            self.publicKey = self.demoPublicKey;
            self.privateKey = self.demoPrivateKey;
            self.useDemoKey = YES;
        }
    }
    return self;
}

+ (instancetype)sharedInstance {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
    return nil;
}

#pragma mark - custom properties

- (NSString *)publicKey {
    
    return [[BKSettingsManager sharedInstance] loadValueForKey:BKSettingsPublicKey forNetworkManager:self];
}

- (void)setPublicKey:(NSString *)publicKey {
    
    [[BKSettingsManager sharedInstance] saveValue:publicKey forKey:BKSettingsPublicKey forNetworkManager:self];
}

- (NSString *)privateKey {
    
    return [[BKSettingsManager sharedInstance] loadValueForKey:BKSettingsPrivateKey forNetworkManager:self];
}

- (void)setPrivateKey:(NSString *)privateKey {
    
    [[BKSettingsManager sharedInstance] saveValue:privateKey forKey:BKSettingsPrivateKey forNetworkManager:self];
}

- (BOOL)useDemoKey {
    
    return [[[BKSettingsManager sharedInstance] loadValueForKey:BKSettingsUseDemoKey forNetworkManager:self] boolValue];
}

- (void)setUseDemoKey:(BOOL)useDemoKey {
    
    NSString *str = [NSString stringWithFormat:@"%d", useDemoKey];
    [[BKSettingsManager sharedInstance] saveValue:str forKey:BKSettingsUseDemoKey forNetworkManager:self];
}

#pragma mark - public methods

+ (void)setCommonQueue:(BKDistinctOperationQueue *)_commonQueue {
    
    @synchronized(self) {
        
        theCommonQueue = _commonQueue;
    }
}

+ (BKDistinctOperationQueue *)commonQueue {
    
    @synchronized(self) {
        
        return theCommonQueue;
    }
}

- (void)sendResponseNotification:(BKResponseNotification)responseNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%d", responseNotification] object:self];
}

#pragma mark - common exchange methods

- (id)incrementalParam {
    
    return @((long)[[NSDate date] timeIntervalSince1970]);
}

- (void)runOperationBySendingGETRequests:(NSArray *)URLStrings
                           arrayOfParams:(NSArray *)arrayOfparams
                        notificationName:(NSString *)notificationName
                           successBLocks:(NSArray *)successBlocks
                           failureBlocks:(NSArray *)failureBlocks {
    
    __block NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        NSError *err = nil;
        for (int i = 0; i < URLStrings.count; i++) {
            
            id params = arrayOfparams[i];
            if ([params isKindOfClass:[NSNull class]]) {
                
                params = nil;
            }
            NSString *paramStr = [BSUtilities requestStringFromParams:params];
            NSString *urlStr = URLStrings[i];
            if (paramStr) {
                
                urlStr = [urlStr stringByAppendingFormat:@"?%@", paramStr];
            }
            NSString *str = [BSUtilities stringWithContentsOfURLString:urlStr error:&err];
            if (err) {
                
                if (failureBlocks) {
                    
                    id oneFailureBlock = failureBlocks[i];
                    if (![oneFailureBlock isKindOfClass:[NSNull class]]) {
                        
                        dispatch_sync([BSUtilities mainQueue], ^{
                            
                            [SVProgressHUD show];
                        });
                        ((BKVoidBlock)oneFailureBlock)();
                        dispatch_sync([BSUtilities mainQueue], ^{
                            
                            [SVProgressHUD popActivity];
                        });
                    }
                }
                [BSUtilities sendNetworkNotificationNamed:notificationName isSuccessful:NO];
                [op cancel];
                return;
            }
            id oneSuccessBlock = successBlocks[i];
            if (![oneSuccessBlock isKindOfClass:[NSNull class]]) {
                
                id obj = [NSDictionary dictionaryWithJsonString:str];
                if (!obj) {
                    
                    obj = [NSArray arrayWithJsonString:str];
                }
                dispatch_sync([BSUtilities mainQueue], ^{
                    
                    [SVProgressHUD show];
                });
                ((BKVoidBlockFromIDObject)oneSuccessBlock)(obj);
                dispatch_sync([BSUtilities mainQueue], ^{
                    
                    [SVProgressHUD popActivity];
                });
            }
        }
        [BSUtilities sendNetworkNotificationNamed:notificationName isSuccessful:YES];
    }];
    [self.commonQueue addOperation:op withIdentifier:[BSUtilities operationIdentifierWithURLStrings:URLStrings params:arrayOfparams]];
}

@end

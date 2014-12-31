//
//  BKNetworkManagerC_Cex.m
//  BTC Keep
//
//  Created by Apple on 20.10.14.
//  
//

#import "BKNetworkManagerC_Cex.h"
#import "BKDataAdapterC_Cex.h"
#import "SVProgressHUD.h"

#define BKKeyC_CexReturn    @"return"

#define BKURLC_CexGetTradePairNames                 @"https://c-cex.com/t/pairs.json"
#define BKURLC_CexGetTradePairs                     @"https://c-cex.com/t/prices.json"
#define BKURLC_CexGetTradePairForID                 @"https://c-cex.com/t/%@.json"
#define BKURLC_CexGetTradePairForCurrencies         @"https://c-cex.com/t/%@-%@.json"
#define BKURLC_CexGetTradesForTradePair             @"https://c-cex.com/t/s.html"
#define BKURLC_CexGetTradeQuantitiesForCurrencies   @"https://c-cex.com/t/s.html"
#define BKURLC_CexGetLastTrades                     @"https://c-cex.com/t/s.html"
#define BKURLC_CexGetOrdersForCurrencies            @"https://c-cex.com/t/r.html"
#define BKURLC_CexGetBalances                       @"https://c-cex.com/t/r.html"
#define BKURLC_CexCreateOrder                       @"https://c-cex.com/t/r.html"
#define BKURLC_CexCancelOrder                       @"https://c-cex.com/t/r.html"
#define BKURLC_CexGetMyTrades                       @"https://c-cex.com/t/r.html"

@implementation BKNetworkManagerC_Cex

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
        
        self.exchangeName = @"C-Cex";
    }])) {
        
    }
    return self;
}

#pragma mark - public request methods

- (void)requestTradePairs {
    
    BKVoidBlockFromIDObject b = ^(id items) {
        
        [[BKDataAdapterC_Cex sharedInstance] updateCurrencies:items];
        [[BKDataAdapterC_Cex sharedInstance] updateTradePairs:items];
    };
    [self runOperationBySendingGETRequests:@[BKURLC_CexGetTradePairs]
                             arrayOfParams:nil
                          notificationName:BKNotificationGotTradePairs
                             successBLocks:@[b]
                             failureBlocks:nil];
}

- (void)requestTradesForTradePairID:(NSString *)tradePairID {
    
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    NSDate *date2 = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    
    NSDateFormatter *dateFormatter = [BSUtilities dateFormatterWithFormat:@"yyyy-MM-dd"];
    NSString *dateFromStr = [dateFormatter stringFromDate:date2];
    NSString *dateToStr = [dateFormatter stringFromDate:date];
    
    BKVoidBlockFromIDObject b = ^(id obj) {
        
        NSArray *items = [BSUtilities safelyGetArray:obj forKey:BKKeyC_CexReturn];
        [[BKDataAdapterC_Cex sharedInstance] updateTrades:items tradePairID:tradePairID];
    };
    NSDictionary *params = @{@"d1" : dateFromStr, @"d2" : dateToStr, @"pair" : tradePairID, @"a" : @"tradehistory"};
    [self runOperationBySendingGETRequests:@[BKURLC_CexGetTradesForTradePair]
                             arrayOfParams:@[params]
                          notificationName:BKNotificationGotTradesForTradePair
                             successBLocks:@[b]
                             failureBlocks:nil];
}

@end

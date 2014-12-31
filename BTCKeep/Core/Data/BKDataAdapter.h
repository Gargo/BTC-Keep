//
//  BKDataAdapter.h
//  BTC Keep
//
//  Created by Apple on 19.06.14.
//  
//

#import <Foundation/Foundation.h>

#import "BKDataManager.h"

@protocol BKDataAdapterPublicMethodsProtocol

//should be overriden in each child
+ (instancetype)sharedInstance;
- (NSArray *)identifiersForEntityNamed:(NSString *)entityName;
- (NSArray *)fillSelectorsForEntityNamed:(NSString *)entityName;

@end

@class BKDataManager;

@interface BKDataAdapter : NSObject<BKDataAdapterPublicMethodsProtocol> {
    
@protected
    BKDataManager *dataManager;
}

- (void)updateCurrencies:(id)currencies;
- (void)updateTradePairs:(id)tradePairs;
- (void)updateTrades:(id)trades tradePairID:(NSString *)tradePairID;

- (void)updateTrades:(id)trades;
- (void)updateOrders:(id)orders;
- (void)updateOrder:(id)order;

@end

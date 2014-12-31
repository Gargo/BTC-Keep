//
//  BKDataAdapter.m
//  BTC Keep
//
//  Created by Apple on 19.06.14.
//  
//

#import "BKDataAdapter.h"

@implementation BKDataAdapter

+ (instancetype)sharedInstance {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
    return nil;
}

- (id)init {
    
    if ((self = [super init])) {
        
        dataManager = [BKDataManager sharedInstance];
    }
    return self;
}

#pragma mark - Update methods

- (void)updateCurrencies:(id)currencies {
    
    [dataManager updateEntititesNamed:BKCurrencyEntity filler:self fillParams:currencies forExchange:self];
}

- (void)updateTradePairs:(id)tradePairs {
    
    [dataManager updateEntititesNamed:BKTradePairEntity filler:self fillParams:tradePairs forExchange:self];
}

- (void)updateTrades:(id)trades tradePairID:(NSString *)tradePairID {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
}

- (void)updateTrades:(id)trades {
    
    [dataManager updateEntititesNamed:BKTradeEntity filler:self fillParams:trades forExchange:self];
}

- (void)updateOrders:(id)orders {
    
//    [dataManager updateOrders:orders withObject:obj andSelector:@selector(fillOrder:withParams:)];
}

- (void)updateOrder:(id)order {
    
//    [dataManager updateOrder:order withObject:obj andSelector:nil];
}

#pragma mark - Private methods

//Should be overriden in child
- (void)fillCurrency:(BKCurrency *)currency withParams:(NSDictionary *)params {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
}

- (void)fillTradePair:(BKTradePair *)tradePair withParams:(NSDictionary *)params {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
}

- (void)fillOrder:(BKOrder *)order withParams:(NSDictionary *)params {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
}

- (void)fillTrade:(BKTrade *)trade withParams:(NSDictionary *)params {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
}

#pragma mark - Public methods

- (NSArray *)identifiersForEntityNamed:(NSString *)entityName {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
    return nil;
}

- (NSArray *)fillSelectorsForEntityNamed:(NSString *)entityName {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
    return nil;
}

@end

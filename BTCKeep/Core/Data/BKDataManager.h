//
//  BKDataManager.h
//  BTCKeep
//
//  Created by Vitali on 9/12/12.
//  
//

#import <Foundation/Foundation.h>

#import "BSUtilities.h"

#import "BKCurrency.h"
#import "BKTrade.h"
#import "BKTradePair.h"
#import "BKOrder.h"

#define BKCurrencyEntity               @"BKCurrency"
#define BKTradeEntity                  @"BKTrade"
#define BKTradePairEntity              @"BKTradePair"
#define BKOrderEntity                  @"BKOrder"

#define BKKeyId                         @"id"
#define BKKeyIdentifier                 @"identifier"
#define BKKeyPrimaryCurrencyId          @"primaryCurrencyId"
#define BKKeySecondaryCurrencyId        @"secondaryCurrencyId"
#define BKKeyTradePairId                @"tradePairId"
#define BKKeyCreatedAt                  @"createdAt"
#define BKKeyExchangeID                 @"exchangeID"

@interface BKDataManager : NSObject {
    
    NSManagedObjectModel *model;
    NSManagedObjectContext *mainContext;
    NSPersistentStoreCoordinator *coordinator;
}

//@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *model;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *coordinator;

+ (instancetype)sharedInstance;

- (NSArray *)getMainCurrenciesForExchange:(id)exchange;
- (NSArray *)getMainCurrenciesIDsForExchange:(id)exchange;
- (NSArray *)getToCurrenciesIDsForSelectedFromCurrencyID:(NSString *)fromCurrencyID forExchange:(id)exchange;
- (NSArray *)getCurrenciesForExchange:(id)exchange;
- (NSArray *)getTradesForExchange:(id)exchange;
- (NSArray *)getTradePairsForExchange:(id)exchange;
- (NSArray *)getOrdersForExchange:(id)exchange;

- (NSArray *)getTradePairsWithCurrencyId:(NSString *)fromCurrencyId forExchange:(id)exchange;
- (BKTradePair *)getTradePairFromCurrencyId:(NSString *)fromCurrencyId toCurrencyId:(NSString *)toCurrencyId forExchange:(id)exchange;
- (NSArray *)getTradesWithTradePairId:(NSString *)tradePairId forExchange:(id)exchange;
- (NSArray *)getTradeIDsWithTradePairId:(NSString *)tradePairId forExchange:(id)exchange;

- (NSArray *)getCurrenciesWithIDs:(NSArray *)ids forExchange:(id)exchange;
- (NSArray *)getTradesWithIDs:(NSArray *)ids forExchange:(id)exchange;
- (NSArray *)filterEntities:(NSArray *)entities withIDs:(NSArray *)ids forExchange:(id)exchange;

//Magical Record
- (void)updateEntitityNamed:(NSString *)name identifierName:(NSString *)identifierName filler:(id)filler fillSelector:(SEL)fillSelector fillParams:(id)fillParams deleteOld:(BOOL)deleteOld forExchange:(id)exchange;
- (void)updateEntititesNamed:(NSString *)name filler:(id)filler fillParams:(id)fillParams forExchange:(id)exchange;

@end

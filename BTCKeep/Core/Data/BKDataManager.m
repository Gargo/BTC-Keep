//
//  BKDataManager.m
//  BTCKeep
//
//  Created by Vitali on 9/12/12.
//  
//

#import "BKDataManager.h"

#import <CoreData/CoreData.h>
#import <objc/message.h>

#import "logger.h"
#import "BKDataAdapter.h"

typedef void (*BKMsgFillObject)(id, SEL, id, id);

@interface  BKDataManager()

@end


@implementation BKDataManager

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self class] new];
    });
    
    return _sharedInstance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

#pragma mark - GET methods

- (NSArray *)getTradePairsForExchange:(id)exchange {
    
    return [BKTradePair BK_findAllSortedBy:BKKeyIdentifier ascending:YES forExchange:exchange];
}

- (NSArray *)getCurrenciesForExchange:(id)exchange {
    
    return [BKCurrency BK_findAllSortedBy:BKKeyIdentifier ascending:YES forExchange:exchange];
}

- (NSArray *)getTradesForExchange:(id)exchange {
    
    return [BKTrade BK_findAllSortedBy:BKKeyIdentifier ascending:YES forExchange:exchange];
}

- (NSArray *)getOrdersForExchange:(id)exchange {
    
    return [BKOrder BK_findAllSortedBy:BKKeyIdentifier ascending:YES forExchange:exchange];
}

- (NSArray *)getMainCurrenciesForExchange:(id)exchange {
    
    return [self getCurrenciesWithIDs:[self getMainCurrenciesIDsForExchange:exchange] forExchange:exchange];
}

- (NSArray *)getMainCurrenciesIDsForExchange:(id)exchange {
    
    NSArray *tradePairs = [BKTradePair BK_findAllForExchange:exchange];
    NSMutableSet *mainCurrenciesIDsSet = [NSMutableSet set];
    for (BKTradePair *oneTradePair in tradePairs) {
        
        [mainCurrenciesIDsSet addObject:oneTradePair.secondaryCurrencyId];
    }
    return [mainCurrenciesIDsSet.allObjects sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)getToCurrenciesIDsForSelectedFromCurrencyID:(NSString *)fromCurrencyID forExchange:(id)exchange {
    
    NSArray *currencyTradePairs = [self getTradePairsWithCurrencyId:fromCurrencyID forExchange:exchange];
    NSMutableArray *pairCurrenciesIDs = [NSMutableArray new];
    for (BKTradePair *tradePair in currencyTradePairs) {
        
        [pairCurrenciesIDs addObject:[BKCurrency BK_findFirstByAttribute:BKKeyIdentifier withValue:tradePair.primaryCurrencyId forExchange:exchange].identifier];
    }
    return pairCurrenciesIDs;
}

- (NSArray *)getTradePairsWithCurrencyId:(NSString *)fromCurrencyId forExchange:(id)exchange {
    
    return [BKTradePair BK_findAllSortedBy:BKKeyPrimaryCurrencyId ascending:YES withDictionary:@{BKKeySecondaryCurrencyId : fromCurrencyId} forExchange:exchange];
}

- (BKTradePair *)getTradePairFromCurrencyId:(NSString *)fromCurrencyId toCurrencyId:(NSString *)toCurrencyId forExchange:(id)exchange {
    
    if (!fromCurrencyId || !toCurrencyId) {
        
        return nil;
    }
    return [BKTradePair BK_findFirstWithDictionary:@{BKKeySecondaryCurrencyId : fromCurrencyId, BKKeyPrimaryCurrencyId : toCurrencyId} forExchange:exchange];
}

- (NSArray *)getTradesWithTradePairId:(NSString *)tradePairId forExchange:(id)exchange {
    
    return [BKTrade BK_findAllSortedBy:BKKeyCreatedAt ascending:YES withDictionary:@{BKKeyTradePairId : tradePairId} forExchange:exchange];
}

- (NSArray *)getTradeIDsWithTradePairId:(NSString *)tradePairId forExchange:(id)exchange {
    
    NSArray *trades = [self getTradesWithTradePairId:tradePairId forExchange:exchange];
    NSMutableArray *ids = [NSMutableArray array];
    for (BKTrade *trade in trades) {
        
        [ids addObject:trade.identifier];
    }
    return ids;
}

- (NSArray *)getCurrenciesWithIDs:(NSArray *)ids forExchange:(id)exchange {
    
    return [self filterEntities:[self getCurrenciesForExchange:exchange] withIDs:ids forExchange:exchange];
}

- (NSArray *)getTradesWithIDs:(NSArray *)ids forExchange:(id)exchange {
    
    return [self filterEntities:[self getTradesForExchange:exchange] withIDs:ids forExchange:exchange];
}

- (NSArray *)filterEntities:(NSArray *)entities withIDs:(NSArray *)ids forExchange:(id)exchange {
    
    NSString *predicateFormat = [BKKeyIdentifier stringByAppendingString:@" IN %@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, ids];
    return [entities filteredArrayUsingPredicate:predicate];
}

#pragma mark - UPDATE methods

- (void)updateEntitityNamed:(NSString *)name identifierName:(NSString *)identifierName filler:(id)filler fillSelector:(SEL)fillSelector fillParams:(id)fillParams deleteOld:(BOOL)deleteOld forExchange:(id)exchange {
    
    if ([fillParams count] > 0) {
        
        dispatch_sync([BSUtilities mainQueue], ^{
            
            Class cl = NSClassFromString(name);
            if ([fillParams isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dict in fillParams) {
                    
                    NSManagedObject *obj = [cl BK_findFirstWithDictionary:@{BKKeyIdentifier : dict[identifierName]} forExchange:exchange];
                    if (obj && deleteOld) {
                        
                        [obj BK_deleteEntity];
                        obj = [cl BK_createEntityForExchange:exchange];
                    } else if (!obj) {
                        
                        obj = [cl BK_createEntityForExchange:exchange];
                    }
                    ((BKMsgFillObject)objc_msgSend)(filler, fillSelector, obj, dict);
                }
            } else if ([fillParams isKindOfClass:[NSDictionary class]]) {
                
                for (NSString *key in fillParams) {
                    
                    NSDictionary *currentFillParams = fillParams[key];
                    NSManagedObject *obj = [cl BK_findFirstWithDictionary:@{BKKeyIdentifier : key} forExchange:exchange];
                    if (obj && deleteOld) {
                        
                        [obj BK_deleteEntity];
                        obj = [cl BK_createEntityForExchange:exchange];
                    } else if (!obj) {
                        
                        obj = [cl BK_createEntityForExchange:exchange];
                    }
                    ((BKMsgFillObject)objc_msgSend)(filler, fillSelector, obj, @{key : currentFillParams});
                }
            }
            [[NSManagedObjectContext BK_defaultContext] BK_save];
        });
    }
}

- (void)updateEntititesNamed:(NSString *)name filler:(id)filler fillParams:(id)fillParams forExchange:(id)exchange {
    
    if ([fillParams count] > 0) {
        
        dispatch_sync([BSUtilities mainQueue], ^{
            
            Class cl = NSClassFromString(name);
            [cl BK_truncateAllForExchange:exchange];
            
            NSArray *identifierNames = [filler identifiersForEntityNamed:name];
            NSArray *fillSelectors = [filler fillSelectorsForEntityNamed:name];
            if ([fillParams isKindOfClass:[NSArray class]]) {
                
                for (int i = 0; i < fillSelectors.count; i++) {
                    
                    NSString *currentIdentifierName = identifierNames[i];
                    SEL currentSelector = NSSelectorFromString(fillSelectors[i]);
                    for (NSDictionary *dict in fillParams) {
                        
                        NSManagedObject *obj = (identifierNames ? [cl BK_findFirstWithDictionary:@{BKKeyIdentifier : dict[currentIdentifierName]} forExchange:exchange] : nil);
                        if (!obj) {
                            
                            obj = [cl BK_createEntityForExchange:exchange];
                            ((BKMsgFillObject)objc_msgSend)(filler, currentSelector, obj, dict);
                        }
                    }
                }
            } else if ([fillParams isKindOfClass:[NSDictionary class]]) {
                
                for (int i = 0; i < fillSelectors.count; i++) {
                    
                    NSString *currentIdentifierName = identifierNames[i];
                    SEL currentSelector = NSSelectorFromString(fillSelectors[i]);
                    for (NSString *key in fillParams) {
                        
                        NSDictionary *currentFillParams = fillParams[key];
                        NSString *predicateKey = (currentFillParams ? currentFillParams[currentIdentifierName] : key);
                        NSManagedObject *obj = (identifierNames ? [cl BK_findFirstWithDictionary:@{BKKeyIdentifier : predicateKey} forExchange:exchange] : nil);
                        if (!obj) {
                            
                            obj = [cl BK_createEntityForExchange:exchange];
                            ((BKMsgFillObject)objc_msgSend)(filler, currentSelector, obj, @{key : currentFillParams});
                        }
                    }
                }
            }
            
            [[NSManagedObjectContext BK_defaultContext] BK_save];
        });
    }
}

- (void)updateEntityNamed:(NSString *)name filler:(id)filler fillDictionary:(NSDictionary *)fillDictionary forExchange:(id)exchange {
    
    Class cl = NSClassFromString(name);
    NSManagedObject *obj = [cl BK_findFirstWithDictionary:@{BKKeyIdentifier : [BSUtilities safelyGetNumber:fillDictionary forKey:BKKeyId]} forExchange:exchange];
    if (!obj) {
        
        obj = [cl BK_createEntityForExchange:exchange];
    }
#warning don't delete this line, but replace fillSelector param
//    objc_msgSend(filler, fillSelector, obj, fillDictionary);
//    [self saveAll];
}

#pragma mark - Data requests

- (NSManagedObject *)getEntity:(NSString *)name forId:(NSString *)identifier forExchange:(id)exchange {
    
    Class cl = NSClassFromString(name);
    return [cl BK_findFirstByAttribute:BKKeyIdentifier withValue:identifier forExchange:exchange];
}

@end

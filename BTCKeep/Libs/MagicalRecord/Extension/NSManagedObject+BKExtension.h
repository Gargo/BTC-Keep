//
//  NSManagedObject+BKExtension.h
//  BTC Keep
//
//  Created by Vyachaslav on 20.10.14.
//  
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (BKExtension)

+ (NSArray *)BK_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending forExchange:(id)exchange;
+ (NSArray *)BK_findAllForExchange:(id)exchange;
+ (instancetype)BK_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue forExchange:(id)exchange;
+ (NSArray *)BK_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withDictionary:(NSDictionary *)theDict forExchange:(id)exchange;
+ (instancetype)BK_findFirstWithDictionary:(NSDictionary *)theDict forExchange:(id)exchange;
- (BOOL)BK_deleteEntity;
+ (id)BK_createEntityForExchange:(id)exchange;
+ (BOOL)BK_truncateAllForExchange:(id)exchange;

@end

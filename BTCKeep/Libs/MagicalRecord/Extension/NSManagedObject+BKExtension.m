//
//  NSManagedObject+BKExtension.m
//  BTC Keep
//
//  Created by Vyachaslav on 20.10.14.
//  
//

#import "NSManagedObject+BKExtension.h"
#import "BKBase.h"

@implementation NSManagedObject (BKExtension)

+ (NSArray *)BK_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending forExchange:(id)exchange {
    
    NSPredicate *predicate = [BSUtilities predicateforExchange:exchange];
    return [self MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:predicate];
}

+ (NSArray *)BK_findAllForExchange:(id)exchange {
    
    NSPredicate *predicate = [BSUtilities predicateforExchange:exchange];
    return [self MR_findAllWithPredicate:predicate];
}

+ (instancetype)BK_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue forExchange:(id)exchange {
    
    NSPredicate *predicate = [BSUtilities predicateWithDictionary:@{attribute : searchValue} forExchange:exchange];
    return [self MR_findFirstWithPredicate:predicate];
}

+ (NSArray *)BK_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withDictionary:(NSDictionary *)theDict forExchange:(id)exchange {
    
    NSPredicate *predicate = [BSUtilities predicateWithDictionary:theDict forExchange:exchange];
    return [self MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:predicate];
}

+ (instancetype)BK_findFirstWithDictionary:(NSDictionary *)theDict forExchange:(id)exchange {
    
    NSPredicate *predicate = [BSUtilities predicateWithDictionary:theDict forExchange:exchange];
    return [self MR_findFirstWithPredicate:predicate];
}

- (BOOL)BK_deleteEntity {
    
    return [self MR_deleteEntity];
}

+ (id)BK_createEntityForExchange:(id)exchange {
    
    BKBase *obj = [self MR_createEntity];
    obj.exchangeID = [BSUtilities exchangeNumberForExchange:exchange];
    return obj;
}

+ (BOOL)BK_truncateAllForExchange:(id)exchange {
    
    NSPredicate *predicate = [BSUtilities predicateforExchange:exchange];
    return [self MR_deleteAllMatchingPredicate:predicate];
}

@end

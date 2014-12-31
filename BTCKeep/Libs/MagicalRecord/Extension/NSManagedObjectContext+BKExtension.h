//
//  NSManagedObjectContext+BKExtension.h
//  BTC Keep
//
//  Created by Vyachaslav on 20.10.14.
//  
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (BKExtension)

+ (NSManagedObjectContext *)BK_defaultContext;
- (void)BK_save;

@end

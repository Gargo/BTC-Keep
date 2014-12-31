//
//  NSManagedObjectContext+BKExtension.m
//  BTC Keep
//
//  Created by Vyachaslav on 20.10.14.
//  
//

#import "NSManagedObjectContext+BKExtension.h"

@implementation NSManagedObjectContext (BKExtension)

+ (NSManagedObjectContext *)BK_defaultContext {
    
    return [self MR_defaultContext];
}

- (void)BK_save {
    
    return [self MR_saveWithOptions:MRSaveSynchronously | MRSaveParentContexts completion:^(BOOL success, NSError *error) {
        
        if (success) {
            
            LOG(@"You successfully saved your context.");
        } else if (error) {
            
            LOG(@"Error saving context: %@", error.description);
        } else {
            
            LOG(@"Nothing changed!!!!!!!!!!!");
        }
    }];
}

@end

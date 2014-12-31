//
//  BKDistinctOperationQueue.h
//  BTC Keep
//
//  Created by Apple on 06.09.14.
//  
//

#import <Foundation/Foundation.h>

@interface BKDistinctOperationQueue : NSOperationQueue

- (void)addOperation:(NSOperation *)op withIdentifier:(NSString *)identifier;
- (void)addOperations:(NSArray *)ops withIdentifiers:(NSArray *)identifiers;

@end

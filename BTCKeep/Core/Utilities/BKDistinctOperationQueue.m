//
//  BKDistinctOperationQueue.m
//  BTC Keep
//
//  Created by Apple on 06.09.14.
//  
//

#import "BKDistinctOperationQueue.h"

#import "BSUtilities.h"

@interface BKDistinctOperationQueue()

@property (strong) NSMutableDictionary *operationDict;

@end

@implementation BKDistinctOperationQueue

@synthesize operationDict;

- (id)init {
    
    if ((self = [super init])) {
        
        self.operationDict = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - public methods

- (void)addOperation:(NSOperation *)op withIdentifier:(NSString *)identifier {
    
//    @synchronized(self) {
//        
//        NSOperation *operation = operationDict[identifier];
//        [operation cancel];
//        [self removeLinksToExtraOperations];
//        operationDict[identifier] = op;
//        [super addOperation:op];
//    }
    [self addOperations:@[op] withIdentifiers:@[identifier]];
}

- (void)addOperations:(NSArray *)ops withIdentifiers:(NSArray *)identifiers {
    
    //identifiers.count + 1 == ops.count
    @synchronized(self) {
        
        for (NSString *oneIdentifier in identifiers) {
            
            NSOperation *operation = operationDict[oneIdentifier];
            [operation cancel];
        }
        [self removeLinksToExtraOperations];
        for (int i = 0; i < identifiers.count; i++) {
            
            NSString *identifier = identifiers[i];
            operationDict[identifier] = ops[i];
        }
        [super addOperations:ops waitUntilFinished:NO];
    }
}

#pragma mark - private methods

- (void)removeLinksToExtraOperations {
    
    NSArray *keys = operationDict.allKeys;
    for (NSString *key in keys) {
        
        NSOperation *op = operationDict[key];
        if (op.isFinished || op.isCancelled) {
            
            [operationDict removeObjectForKey:key];
        }
    }
}

#pragma mark - overriden methods

- (void)cancelAllOperations {
    
    self.operationDict = [NSMutableDictionary dictionary];
    [super cancelAllOperations];
}

- (void)addOperation:(NSOperation *)op {
    
    [BSUtilities raiseForbiddenMethodExceptionForSelector:_cmd
                                     substitutiveSelector:@selector(addOperation:withIdentifier:)];
}

@end

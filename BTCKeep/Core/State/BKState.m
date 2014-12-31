//
//  BKState.m
//  BTCKeep
//
//  Created by Vitali on 9/6/12.
//  
//

#import "BKState.h"

@implementation BKState


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


#pragma mark - Public methods


#pragma mark - Private methods


@end

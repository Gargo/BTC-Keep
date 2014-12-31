//
//  BKGlobalConstantBox.m
//  BTCKeep
//
//  Created by Apple on 28.05.14.
//  
//

#import "BKGlobalConstantBox.h"

@implementation BKGlobalConstantBox

+ (BKGlobalConstantBox *)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self class] new];
    });
    
    return _sharedInstance;
}

@end

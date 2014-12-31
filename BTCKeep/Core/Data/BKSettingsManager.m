//
//  BKSettingsManager.m
//  BTC Keep
//
//  Created by Apple on 04.07.14.
//  
//

#import "BKSettingsManager.h"
#import "BKNetworkManagerBox.h"
#import "BKNetworkManager.h"
#import "PDKeychainBindings.h"

@implementation BKSettingsManager

static BKSettingsManager *instance;

+ (BKSettingsManager *)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self class] new];
    });
    
    return _sharedInstance;
}

- (id)init {
    
    if ((self = [super init])) {
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        keychainBindings = [PDKeychainBindings sharedKeychainBindings];
    }
    return self;
}

#pragma mark - private methods

- (void)saveValue:(id)value forKey:(id)key {
    
    [keychainBindings setObject:value forKey:key];
}

- (id)loadValueForKey:(id)key {
    
    return [keychainBindings objectForKey:key];
}

#pragma mark - public methods

- (void)saveValue:(NSString *)value forKey:(id)key forNetworkManager:(BKNetworkManager *)manager {
    
    [self saveValue:value forKey:[[manager exchangeName] stringByAppendingString:key]];
}

- (NSString *)loadValueForKey:(id)key forNetworkManager:(BKNetworkManager *)manager {
    
    return [self loadValueForKey:[[manager exchangeName] stringByAppendingString:key]];
}

@end

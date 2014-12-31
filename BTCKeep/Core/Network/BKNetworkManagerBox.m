//
//  BKNetworkManagerBox.m
//  BTC Keep
//
//  Created by Apple on 15.06.14.
//  
//

#import "BKNetworkManagerBox.h"

#import "BKNetworkManagerCryptsy.h"
#import "BKNetworkManagerCoins_E.h"
#import "BKNetworkManagerBitstamp.h"
#import "BKNetworkManagerLocalBitcoins.h"
#import "BKNetworkManagerC_Cex.h"
#import "BKNetworkManagerBter.h"

@implementation BKNetworkManagerBox

@synthesize networkManagers;

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[self class] new];
    });
    
    return _sharedInstance;
}

- (id)init {
    
    if ((self = [super init])) {
        
        self.networkManagers = [NSMutableArray array];
        [networkManagers addObject:[BKNetworkManagerBitstamp sharedInstance]];
        [networkManagers addObject:[BKNetworkManagerC_Cex sharedInstance]];
        [networkManagers addObject:[BKNetworkManagerCoins_E sharedInstance]];
        [networkManagers addObject:[BKNetworkManagerCryptsy sharedInstance]];
        [networkManagers addObject:[BKNetworkManagerLocalBitcoins sharedInstance]];
        [networkManagers addObject:[BKNetworkManagerBter sharedInstance]];
    }
    return self;
}

+ (NSArray *)networkManagerNamesFromManagers:(NSArray *)managers {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (BKNetworkManager *nm in managers) {
        
        [arr addObject:nm.exchangeName];
    }
    return arr;
}

- (NSArray *)managersForMainScreen {
    
    return networkManagers;
}

- (NSArray *)managersForCalculator {
    
    return networkManagers;
}

- (NSArray *)managersForSettingsScreen {
    
    return @[[BKNetworkManagerCryptsy sharedInstance]];
}

@end

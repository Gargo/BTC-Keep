//
//  BKNetworkManagerBox.h
//  BTC Keep
//
//  Created by Apple on 15.06.14.
//  
//

#import <Foundation/Foundation.h>

@interface BKNetworkManagerBox : NSObject

@property (nonatomic, strong) NSMutableArray *networkManagers;

+ (instancetype)sharedInstance;

+ (NSArray *)networkManagerNamesFromManagers:(NSArray *)managers;

- (NSArray *)managersForMainScreen;
- (NSArray *)managersForCalculator;
- (NSArray *)managersForSettingsScreen;

@end

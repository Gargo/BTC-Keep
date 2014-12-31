//
//  BKSettingsManager.h
//  BTC Keep
//
//  Created by Apple on 04.07.14.
//  
//

#import <Foundation/Foundation.h>

#define BKSettingsPublicKey     @"publicKey"
#define BKSettingsPrivateKey    @"privateKey"
#define BKSettingsUseDemoKey    @"useDemoKey"

@class PDKeychainBindings;
@class BKNetworkManager;

@interface BKSettingsManager : NSObject {
    
    NSUserDefaults *userDefaults;
    PDKeychainBindings *keychainBindings;
}

+ (BKSettingsManager *)sharedInstance;

- (void)saveValue:(NSString *)value forKey:(id)key forNetworkManager:(BKNetworkManager *)manager;
- (NSString *)loadValueForKey:(id)key forNetworkManager:(BKNetworkManager *)manager;

@end

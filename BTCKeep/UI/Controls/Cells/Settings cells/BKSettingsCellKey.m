//
//  BKSettingsCellKey.m
//  BTC Keep
//
//  Created by Vyachaslav on 30.09.14.
//  
//

#import "BKSettingsCellKey.h"

@implementation BKSettingsCellKey

@synthesize lbl, txtField;

- (void)setEnabled:(BOOL)isEnabled {
    
    lbl.enabled = isEnabled;
    txtField.enabled = isEnabled;
}

@end

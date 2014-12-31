//
//  BKSettingsViewController.h
//  BTC Keep
//
//  Created by Apple on 05.05.14.
//  
//

#import <UIKit/UIKit.h>

#import "AMBTableViewController.h"

@interface BKSettingsViewController : AMBTableViewController

@property (nonatomic, strong) NSArray *managers;

- (IBAction)btnToggleClicked:(id)sender;
- (IBAction)switchKeysValueChanged:(id)sender;
- (IBAction)txtFieldKeyEditingChanged:(id)sender;
- (IBAction)btnLinkClicked:(id)sender;

@end

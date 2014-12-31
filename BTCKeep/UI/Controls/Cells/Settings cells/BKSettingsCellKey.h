//
//  BKSettingsCellKey.h
//  BTC Keep
//
//  Created by Vyachaslav on 30.09.14.
//  
//

#import <UIKit/UIKit.h>

@interface BKSettingsCellKey : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbl;
@property (nonatomic, weak) IBOutlet UITextField *txtField;

@property (nonatomic, assign) BOOL isPrivate;

- (void)setEnabled:(BOOL)isEnabled;

@end

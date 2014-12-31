//
//  BKChoiceButton.h
//  BTC Keep
//
//  Created by Apple on 05.09.14.
//  
//

#import <UIKit/UIKit.h>

#import "BKChoiceViewController.h"

@class BKChoiceButton;

@protocol BKChoiceButtonDelegate

- (void)choiceSender:(BKChoiceButton *)sender chosenIndex:(int)index chosenObject:(id)obj;

@end

@interface BKChoiceButton : UIButton <BKChoiceViewControllerDelegate>

@property (nonatomic, assign) IBOutlet id<BKChoiceButtonDelegate> delegate;

- (void)setDataSource:(NSArray *)dataSource;

@end

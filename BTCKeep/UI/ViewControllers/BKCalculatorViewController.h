//
//  BKCalculatorViewController.h
//  BTC Keep
//
//  Created by Apple on 05.05.14.
//  
//

#import <UIKit/UIKit.h>

#import "BKViewController.h"
#import "BKChoiceButton.h"

@interface BKCalculatorViewController : BKViewController <UITextFieldDelegate, BKChoiceButtonDelegate>

- (IBAction)txtFromChanged:(id)sender;
- (IBAction)txtClicked:(id)sender;

@end

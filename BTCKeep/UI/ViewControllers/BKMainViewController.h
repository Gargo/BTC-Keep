//
//  BKMainViewController.h
//  BTC Keep
//
//  Created by Apple on 30.04.14.
//  
//

#import <UIKit/UIKit.h>

#import "BKCurrencyInfoView.h"
#import "BKViewController.h"
#import "SDSegmentedControl.h"
#import "BKGraphView.h"
#import "BKChoiceButton.h"

@interface BKMainViewController : BKViewController <BKCurrencyInfoViewDelegate, SDSegmentedControlDelegate, BKGraphViewDelegate, BKChoiceButtonDelegate> {

}

@end

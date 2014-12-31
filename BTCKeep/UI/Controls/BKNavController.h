//
//  BKNavController.h
//  BK
//
//  Created by Vitali Lavrentikov on 29.08.12.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BKChoiceViewController.h"

@class BKNavController;

@interface UIViewController(BKNavController)

@property (nonatomic, readonly, getter = customNavigationController) BKNavController *customNavigationController;

+ (BKNavController *)customNavigationController;

@end

@interface BKNavController : UINavigationController

- (UIViewController *)returnToPreviousView;
- (UIViewController *)returnToPreviousViewAnimated:(BOOL)animated;
- (void)returnToMainViewAnimated:(BOOL)animated;

- (void)showChoiceViewFromSender:(id<BKChoiceViewControllerDelegate>)sender dataSource:(NSArray *)dataSource;

@end

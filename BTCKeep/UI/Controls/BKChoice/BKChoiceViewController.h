//
//  BKChoiceViewController.h
//  BTC Keep
//
//  Created by Apple on 05.09.14.
//  
//

#import <UIKit/UIKit.h>

@class BKChoiceViewController;

@protocol BKChoiceViewControllerDelegate

- (void)choiceSender:(BKChoiceViewController *)sender chosenIndex:(int)index chosenObject:(id)obj;

@end

@interface BKChoiceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, assign) id<BKChoiceViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *dataSource;

@end

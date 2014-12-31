//
//  BKPickerTableViewController.h
//  BTC Keep
//
//  Created by Apple on 05.05.14.
//  
//

#import <UIKit/UIKit.h>

typedef enum {
    
    BKPickerDataTypeMainViewStockExchanges = 0,
    BKPickerDataTypeCalculatorViewStockExchanges,
    BKPickerDataTypeFromPairs,
    BKPickerDataTypeToPairs
    
} BKPickerDataType;


@interface BKPickerTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BKPickerDataType pickerDataType;
@property (nonatomic, strong) NSString *selectedItemTitle;
@property (nonatomic, strong) id selectedItem;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

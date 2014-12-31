//
//  BKPickerTableViewController.m
//  BTC Keep
//
//  Created by Apple on 05.05.14.
//  
//

#import "BKPickerTableViewController.h"

#import "BSUtilities.h"
#import "BKMainViewController.h"


@interface BKPickerTableViewController ()

@end


@implementation BKPickerTableViewController


@synthesize dataSource;
@synthesize pickerDataType;
@synthesize selectedItemTitle;
@synthesize selectedItem;
@synthesize selectedIndexPath;


#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getLocalized];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:BKSegueIdUnwindToMainView]
        || [segue.identifier isEqualToString:BKSegueIdUnwindToCalculatorView]) {
        
        selectedItemTitle = [(UITableViewCell *)sender textLabel].text;
    }
}


#pragma mark - Private methods

- (void)getLocalized {
    
    [self setNavigationTitle];
}

- (void)setNavigationTitle {
    
    switch (pickerDataType) {
            
        case BKPickerDataTypeMainViewStockExchanges:
        case BKPickerDataTypeCalculatorViewStockExchanges:
        {
            self.title = BKLocalizedString(@"Stock exchanges title");
            break;
        }
        case BKPickerDataTypeFromPairs:
        {
            self.title = BKLocalizedString(@"From pairs title");
            break;
        }
        case BKPickerDataTypeToPairs:
        {
            self.title = BKLocalizedString(@"To pairs title");
            break;
        }
    }
}


#pragma mark - UITableViewDataSource methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return [BSUtilities abc].count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"DataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([dataSource[indexPath.row] isKindOfClass:[NSString class]]) {
        
        cell.textLabel.text = dataSource[indexPath.row];
    } else {
        
        cell.textLabel.text = [dataSource[indexPath.row] name];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedItem = dataSource[indexPath.row];
    self.selectedIndexPath = indexPath;
    if (pickerDataType == BKPickerDataTypeMainViewStockExchanges) {
        
        [self performSegueWithIdentifier:BKSegueIdUnwindToMainView sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
    else {
        
        [self performSegueWithIdentifier:BKSegueIdUnwindToCalculatorView sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
}


@end

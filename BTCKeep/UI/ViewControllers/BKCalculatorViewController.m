//
//  BKCalculatorViewController.m
//  BTC Keep
//
//  Created by Apple on 05.05.14.
//  
//

#import "BKCalculatorViewController.h"

#import "BKPickerTableViewController.h"

#import "BKDataManager.h"
#import "BKNetworkManager.h"
#import "BKNetworkManagerBox.h"
#import "SVProgressHUD.h"

@interface BKCalculatorViewController ()

@property (nonatomic, weak) IBOutlet BKChoiceButton *btnChooseExchange;
@property (nonatomic, weak) IBOutlet BKChoiceButton *btnFromPairs;
@property (nonatomic, weak) IBOutlet BKChoiceButton *btnToPairs;
@property (nonatomic, weak) IBOutlet UILabel *lblExchange;
@property (nonatomic, weak) IBOutlet UILabel *lblFrom;
@property (nonatomic, weak) IBOutlet UILabel *lblRate;
@property (nonatomic, weak) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UITextField *txtFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtRate;
@property (weak, nonatomic) IBOutlet UILabel *lblCalculationResult;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (nonatomic, strong) NSString *selectedFromCurrencyId;
@property (nonatomic, strong) NSString *selectedToCurrencyId;
@property (nonatomic, strong) NSArray *networkManagers;

//Cached data
@property (nonatomic, strong) NSArray *fromCurrencyIDs;
@property (nonatomic, strong) NSArray *toCurrencyIDs;

@end


@implementation BKCalculatorViewController

@synthesize btnChooseExchange, btnFromPairs, btnToPairs, lblExchange, lblFrom, lblRate, lblResult, selectedFromCurrencyId, selectedToCurrencyId, txtFrom, txtRate, lblCalculationResult, backgroundView, networkManagers, fromCurrencyIDs, toCurrencyIDs, shouldRefresh;

- (id)init {
    
    if ((self = [super init])) {
        
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit {
    
    networkManagers = [[BKNetworkManagerBox sharedInstance] managersForMainScreen];
}

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [BSUtilities fillView:backgroundView withPatternImageNamed:@"bg_pattern.png"];
    [self getLocalized];
    
    [self setNavBarWithType:BKNavBarTypeDefault];
    [btnChooseExchange setDataSource:[BKNetworkManagerBox networkManagerNamesFromManagers:networkManagers]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTradePairsWithNotification:) name:BKNotificationGotTradePairs object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTradesForTradePairWithNotification:) name:BKNotificationGotTradesForTradePair object:nil];
    
    if (shouldRefresh) {
    
        [self refresh];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (void)setCurrentExchangeIndex:(int)index {
    
    [super setCurrentExchangeIndex:index];
    
    [self requestTradePairs];
}

- (void)getLocalized {
    
    self.title = BKLocalizedString(@"Calculator title");
    
    lblExchange.text = BKLocalizedString(@"Exchange txt");
    lblFrom.text = BKLocalizedString(@"From txt");
    lblRate.text = BKLocalizedString(@"Rate txt");
    lblResult.text = BKLocalizedString(@"Result txt");
    
    [btnFromPairs setTitle:@"" forState:UIControlStateNormal];
    [btnToPairs setTitle:@"" forState:UIControlStateNormal];
}

- (void)clearCalculations {
    
    txtFrom.text = lblCalculationResult.text = @"";
}

- (void)fillBottomCurrencies {
    
    [SVProgressHUD show];
    dispatch_async([BSUtilities globalQueue], ^{
        
        self.toCurrencyIDs = [dataManager getToCurrenciesIDsForSelectedFromCurrencyID:selectedFromCurrencyId
                                                                          forExchange:networkManagers[currentNetworkManager]];
        dispatch_async([BSUtilities mainQueue], ^{
            
            NSArray *toCurrencies = [dataManager getCurrenciesWithIDs:toCurrencyIDs
                                                          forExchange:networkManagers[currentNetworkManager]];
            if (toCurrencyIDs.count > 0) {
                
                self.selectedToCurrencyId = toCurrencyIDs[0];
                NSArray *currencyNames = [toCurrencies valueForKeyPath:@"name"];
                [btnToPairs setDataSource:currencyNames];
            } else {
                
                self.selectedToCurrencyId = @"-1";
                [btnToPairs setDataSource:nil];
                [BSUtilities showWarningWithText:BKLocalizedString(@"No trade pairs msg")];
            }
            [self updateExchangeRate];
            [self txtFromChanged:self];
            [SVProgressHUD popActivity];
        });
    });
}

- (void)updateExchangeRate {
    
    if (toCurrencyIDs.count > 0) {
        
        BKTradePair *tradePair = [dataManager getTradePairFromCurrencyId:selectedFromCurrencyId
                                                            toCurrencyId:selectedToCurrencyId
                                                             forExchange:networkManagers[currentNetworkManager]];
        txtRate.text = [BSUtilities stringWithNumberPrice:tradePair.lastRate];
        [self txtFromChanged:nil];
    }
}

#pragma mark - BKChoiceButtonDelegate methods

- (void)choiceSender:(BKChoiceButton *)sender chosenIndex:(int)index chosenObject:(id)obj {
    
    if ([sender isEqual:btnChooseExchange]) {
        
        shouldRefresh = YES;
        currentNetworkManager = index;
    } else if ([sender isEqual:btnFromPairs]) {
        
        shouldRefresh = NO;
        selectedFromCurrencyId = fromCurrencyIDs[index];
        [self fillBottomCurrencies];
    } else {
        
        shouldRefresh = NO;
        selectedToCurrencyId = toCurrencyIDs[index];
        [self updateExchangeRate];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > BKMaxPriceStringLength) {
        
        return NO;
    } else {

        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,8})?)?$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    return YES;
}

#pragma mark - UITextField actions

- (IBAction)txtFromChanged:(id)sender {
    
    double rate = txtRate.text.doubleValue;
    double result = (rate > 0) ? (txtFrom.text.doubleValue / rate) : 0;
    lblCalculationResult.text = [BSUtilities stringWithPrice:result];
}

- (IBAction)txtClicked:(id)sender {
    
    LOG(@"txtClicked");
}

#pragma mark - Network requests

- (void)requestTradePairs {
    
    if ([networkManagers[currentNetworkManager] respondsToSelector:@selector(requestTradePairs)]) {
        
        [networkManagers[currentNetworkManager] requestTradePairs];
    }
}

- (void)requestTradesForTradePairId:(NSString *)tradePairID {
    
    if ([networkManagers[currentNetworkManager] respondsToSelector:@selector(requestTradesForTradePairID:)]) {
        
        [networkManagers[currentNetworkManager] requestTradesForTradePairID:tradePairID];
    }
}

#pragma mark - navigation bar actions

- (void)refresh {
    
    [self setCurrentExchangeIndex:currentNetworkManager];
}

#pragma mark - notifications

- (void)gotTradePairsWithNotification:(NSNotification *)notification {
    
    if ([BSUtilities isNetworkNotificationSuccessful:notification]) {
        
        [SVProgressHUD show];
        dispatch_async([BSUtilities mainQueue], ^{
            
            self.fromCurrencyIDs = [dataManager getMainCurrenciesIDsForExchange:networkManagers[currentNetworkManager]];
            if (fromCurrencyIDs.count > 0) {
                
                NSArray *fromCurrencies = [dataManager getCurrenciesWithIDs:fromCurrencyIDs
                                                                forExchange:networkManagers[currentNetworkManager]];
                selectedFromCurrencyId = [(BKCurrency *)fromCurrencies[0] identifier];
                NSArray *currencyNames = [fromCurrencies valueForKeyPath:@"name"];
                [btnFromPairs setDataSource:currencyNames];
            }
            self.toCurrencyIDs = [dataManager getToCurrenciesIDsForSelectedFromCurrencyID:selectedFromCurrencyId
                                                                              forExchange:networkManagers[currentNetworkManager]];
            if (toCurrencyIDs.count) {
                
                NSArray *toCurrencies = [dataManager getCurrenciesWithIDs:toCurrencyIDs
                                                              forExchange:networkManagers[currentNetworkManager]];
                selectedToCurrencyId = [(BKCurrency *)toCurrencies[0] identifier];
                NSArray *currencyNames = [toCurrencies valueForKeyPath:@"name"];
                [btnToPairs setDataSource:currencyNames];
            }
            [SVProgressHUD popActivity];
            dispatch_async([BSUtilities globalQueue], ^{
                
                BKTradePair *selectedTradePair = [dataManager getTradePairFromCurrencyId:selectedFromCurrencyId
                                                                            toCurrencyId:selectedToCurrencyId
                                                                             forExchange:networkManagers[currentNetworkManager]];
                [self requestTradesForTradePairId:selectedTradePair.identifier];
            });
        });
    } else {
        
        [self showErrorConnectingToServer];
    }
}

- (void)gotTradesForTradePairWithNotification:(NSNotification *)notification {
    
    if ([BSUtilities isNetworkNotificationSuccessful:notification]) {
        
        [self fillBottomCurrencies];
    } else {
        
        [self showErrorConnectingToServer];
    }
}

@end

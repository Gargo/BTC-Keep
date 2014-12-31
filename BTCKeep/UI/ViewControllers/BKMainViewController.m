//
//  BKMainViewController.m
//  BTC Keep
//
//  Created by Apple on 30.04.14.
//  
//

#import "BKMainViewController.h"

#import "BKPickerTableViewController.h"
#import "BKNetworkManagerBox.h"
#import "BKNetworkManager.h"

#import "BKCurrency.h"
#import "BKTradePair.h"
#import "BKDataManager.h"
#import "SVProgressHud.h"

#define BKControlGraphIndex                  0
#define BKControlCurrencyInfoIndex           1

#define BKControlsNumKey                     2
#define BKPlotIdentifier           @"nyxnyxnyx"

@interface BKMainViewController ()

@property (weak, nonatomic) IBOutlet SDSegmentedControl *fromSegmentedControl;
@property (weak, nonatomic) IBOutlet SDSegmentedControl *toSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *vcBoxView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet BKChoiceButton *btnChooseExchange;
@property (nonatomic, weak) IBOutlet UILabel *lblExchange;
@property (nonatomic, weak) IBOutlet UILabel *lblFrom;
@property (nonatomic, weak) IBOutlet UILabel *lblTo;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;

@property (strong, nonatomic) BKGraphView *graphView;
@property (nonatomic, strong) BKGraphView *graphViewFullscreen;
@property (nonatomic, strong) BKCurrencyInfoView *currencyInfoView;
@property (nonatomic, strong) CPTGraphHostingView *hostView;

@property (strong) NSString *selectedFromCurrencyId;
@property (strong) NSString *selectedToCurrencyId;
@property (nonatomic, strong) NSArray *networkManagers;

//Cached data
@property (strong) NSArray *fromCurrencyIDs;
@property (strong) NSArray *toCurrencyIDs;

@end


@implementation BKMainViewController

@synthesize fromSegmentedControl, toSegmentedControl, vcBoxView, pageControl, scrollView, currencyInfoView, btnChooseExchange, lblExchange, lblFrom, lblTo, selectedFromCurrencyId, selectedToCurrencyId, hostView, backgroundView, networkManagers, graphView, graphViewFullscreen, fromCurrencyIDs, toCurrencyIDs;

#pragma mark - View controller lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit {
    
    networkManagers = [[BKNetworkManagerBox sharedInstance] managersForMainScreen];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavBarWithType:BKNavBarTypeDefault];
    fromSegmentedControl.delegate = self;
    toSegmentedControl.delegate = self;
    [self getLocalized];
    
    [btnChooseExchange setDataSource:[BKNetworkManagerBox networkManagerNamesFromManagers:networkManagers]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTradePairsWithNotification:) name:BKNotificationGotTradePairs object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTradesForTradePairWithNotification:) name:BKNotificationGotTradesForTradePair object:nil];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (NSDate *)dateForDateString:(NSString *)tradeCreation {
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", [tradeCreation substringToIndex:10], [tradeCreation substringWithRange:NSMakeRange(11, 8)]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:BKCommonDateFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}

- (int)timeIntervalForDateString:(NSString *)tradeCreation {
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", [tradeCreation substringToIndex:10], [tradeCreation substringWithRange:NSMakeRange(11, 8)]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:BKCommonDateFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    return (int)[dateFromString timeIntervalSince1970];
}

- (void)layoutContent {
    
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * BKControlsNumKey, scrollView.bounds.size.height);
    
    if (!graphView) {
        
        graphView = [[BKGraphView alloc] initWithFrame:scrollView.bounds];
        [graphView resetWithTrades:nil];
        graphView.delegate = self;
        [scrollView addSubview:graphView];
    }
    
    if (!graphViewFullscreen) {
        
        graphViewFullscreen = [[BKGraphView alloc] initWithFrame:self.backgroundView.frame];
        graphViewFullscreen.gesturesEnabled = YES;
        [graphViewFullscreen resetWithTrades:nil];
        [self.view addSubview:graphViewFullscreen];
        graphViewFullscreen.delegate = self;
        [graphViewFullscreen setRotationInLandscapeMode:YES];
        graphViewFullscreen.hidden = YES;
    }
    
    [self createCurrencyInfoView];
}

- (void)createCurrencyInfoView {
    
    currencyInfoView = [[BKCurrencyInfoView alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width * BKControlCurrencyInfoIndex, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
    currencyInfoView.delegate = self;
    [scrollView addSubview:currencyInfoView];
}

#pragma mark - Localization

- (void)getLocalized {
    
    self.title = BKLocalizedString(@"BTC Keep title");
    lblExchange.text = BKLocalizedString(@"Exchange txt");
    lblFrom.text = BKLocalizedString(@"From txt");
    lblTo.text = BKLocalizedString(@"To txt");
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


#pragma mark - Content update methods

- (void)updateBottomCurrenciesForSelectedTopCurrency:(BKCurrency *)topCurrency {
    
    self.selectedFromCurrencyId = topCurrency.identifier;
    dispatch_async([BSUtilities globalQueue], ^{
        
        self.toCurrencyIDs = [dataManager getToCurrenciesIDsForSelectedFromCurrencyID:selectedFromCurrencyId
                                                                          forExchange:networkManagers[currentNetworkManager]];
        dispatch_async([BSUtilities mainQueue], ^{
            
            [self setSegmentedControl:toSegmentedControl withCurrencies:[dataManager getCurrenciesWithIDs:toCurrencyIDs
                                                                                              forExchange:networkManagers[currentNetworkManager]]];
            [toSegmentedControl selectSegmentIndex:0];
        });
    });
}

- (void)updateTradePairInfoForSelectedBottomCurrency:(BKCurrency *)bottomCurrency {
    
    self.selectedToCurrencyId = bottomCurrency.identifier;
    dispatch_async([BSUtilities globalQueue], ^{
        
        BKTradePair *selectedTradePair = [dataManager getTradePairFromCurrencyId:selectedFromCurrencyId
                                                                    toCurrencyId:selectedToCurrencyId
                                                                     forExchange:networkManagers[currentNetworkManager]];
        if (selectedTradePair.identifier) {
            
            [self requestTradesForTradePairId:selectedTradePair.identifier];
        }
    });
}

- (void)setSegmentedControl:(UISegmentedControl *)sControl withCurrencies:(NSArray *)currencies {
    
    [sControl removeAllSegments];
    NSArray *segmentCurrencies = [[[currencies copy] reverseObjectEnumerator] allObjects];
    
    for (BKCurrency *currency in segmentCurrencies) {
        
        [sControl insertSegmentWithTitle:currency.name atIndex:0 animated:NO];
    }
    sControl.selectedSegmentIndex = 0;
}

- (void)setCurrentExchangeIndex:(int)index {
    
    [super setCurrentExchangeIndex:index];
    
    [fromSegmentedControl removeAllSegments];
    [toSegmentedControl removeAllSegments];
    
    [self performSelector:@selector(layoutContent) withObject:nil afterDelay:0];
    
    [self requestTradePairs];
    
    [BSUtilities fillView:backgroundView withPatternImageNamed:@"bg_pattern.png"];
}

#pragma mark - Navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Main View Stock Exchanges Data Picker Segue"]) {
        
        BKPickerTableViewController *controller = segue.destinationViewController;
        controller.dataSource = [BSUtilities exchangeTitlesForNetworkManagers:networkManagers];
        controller.pickerDataType = BKPickerDataTypeMainViewStockExchanges;
    }
}

- (IBAction)unwindToMainView:(UIStoryboardSegue *)unwindSegue {
    
    if ([unwindSegue.identifier isEqualToString:BKSegueIdUnwindToMainView]) {
        
        BKPickerTableViewController *vc = unwindSegue.sourceViewController;
        [btnChooseExchange setTitle:vc.selectedItemTitle forState:UIControlStateNormal];
        [self setCurrentExchangeIndex:vc.selectedIndexPath.row];
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        
        pageControl.currentPage = (int)aScrollView.contentOffset.x / aScrollView.bounds.size.width;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    pageControl.currentPage = (int)aScrollView.contentOffset.x / aScrollView.bounds.size.width;
}

#pragma mark - BKCurrencyInfoViewDelegate methods

- (void)currencyInfoViewWillShowCalculatorView {
    
    [self performSegueWithIdentifier:@"Calculator View Segue" sender:nil];
}

#pragma mark - SDSegmentedControlDelegate methods

- (void)segmentedControl:(SDSegmentedControl *)segmentedControl didSelectItemAtIndex:(NSInteger)index {
    
    if (segmentedControl == fromSegmentedControl) {
        
        BKCurrency *selectedFromCurrency = [BKCurrency MR_findFirstByAttribute:BKKeyIdentifier withValue:fromCurrencyIDs[index]];
        [self updateBottomCurrenciesForSelectedTopCurrency:selectedFromCurrency];
    }
    else if (segmentedControl == toSegmentedControl) {
        
        BKCurrency *selectedToCurrency = [BKCurrency MR_findFirstByAttribute:BKKeyIdentifier withValue:toCurrencyIDs[index]];
        [self updateTradePairInfoForSelectedBottomCurrency:selectedToCurrency];
    }
}

#pragma mark - BKGraphViewDelegate

- (void)graphTouched:(id)sender {
    
    if ([sender isEqual:graphView]) {
        
        graphViewFullscreen.hidden = NO;
    } else {
        
        graphViewFullscreen.hidden = YES;
    }
}

#pragma mark - navigation bar actions

- (void)refresh {
    
    [self setCurrentExchangeIndex:currentNetworkManager];
}

#pragma mark - BKChoiceButtonDelegate methods

- (void)choiceSender:(BKChoiceButton *)sender chosenIndex:(int)index chosenObject:(id)obj {
    
    currentNetworkManager = index;
}

#pragma mark - notifications

- (void)gotTradePairsWithNotification:(NSNotification *)notification {
    
    if ([BSUtilities isNetworkNotificationSuccessful:notification]) {

        dispatch_async([BSUtilities mainQueue], ^{
            
            [SVProgressHUD show];
            dispatch_async([BSUtilities globalQueue], ^{
                
                self.fromCurrencyIDs = [dataManager getMainCurrenciesIDsForExchange:networkManagers[currentNetworkManager]];
                dispatch_async([BSUtilities mainQueue], ^{
                    
                    NSArray *fromCurrencies = [dataManager getCurrenciesWithIDs:fromCurrencyIDs
                                                                    forExchange:networkManagers[currentNetworkManager]];
                    [self setSegmentedControl:fromSegmentedControl withCurrencies:fromCurrencies];
                    [fromSegmentedControl selectSegmentIndex:0];
                    [SVProgressHUD popActivity];
                });
            });
        });
    } else {
        
        [self showErrorConnectingToServer];
    }
}

- (void)gotTradesForTradePairWithNotification:(NSNotification *)notification {
    
    if ([BSUtilities isNetworkNotificationSuccessful:notification]) {
        
        dispatch_async([BSUtilities mainQueue], ^{
            
            [SVProgressHUD show];
            dispatch_async([BSUtilities mainQueue], ^{
                
                BKTradePair *tradePair = [dataManager getTradePairFromCurrencyId:selectedFromCurrencyId
                                                                    toCurrencyId:selectedToCurrencyId
                                                                     forExchange:networkManagers[currentNetworkManager]];
                if (tradePair) {
                    
                    [currencyInfoView setTradePair:tradePair];
                    NSArray *recentTrades = [dataManager getTradesWithTradePairId:tradePair.identifier
                                                                      forExchange:networkManagers[currentNetworkManager]];
                    [graphView resetWithTrades:recentTrades];
                    [graphViewFullscreen resetWithTrades:recentTrades];
                    [graphViewFullscreen setRotationInLandscapeMode:YES];
                }
                [SVProgressHUD popActivity];
            });
        });
    } else {
        
        [self showErrorConnectingToServer];
    }
}

@end

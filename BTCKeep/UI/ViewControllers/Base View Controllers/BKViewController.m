//
//  BKViewController.m
//  BTCKeep
//
//  Created by Vitali on 9/6/12.
//  
//

#import "BKViewController.h"

#import "BKNavController.h"
#import "BKDataManager.h"
#import "BKNetworkManager.h"
#import "BKNetworkManagerBox.h"

@interface BKViewController()

@property (readwrite, nonatomic, strong) UIRefreshControl *refreshControl;

@end


@implementation BKViewController

- (id)init {
    
    if ((self = [super init])) {
        
        [self defInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self defInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
        [self defInit];
    }
    return self;
}

- (void)defInit {
    
    self.shouldRefresh = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    dataManager = [BKDataManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

#pragma mark - Public methods

- (void)setCurrentExchangeIndex:(int)index {
    
    currentNetworkManager = index;
}

#pragma mark - handle errors methods

- (void)showErrorConnectingToServer {
    
    [BSUtilities showErrorWithText:BKLocalizedString(@"Can't connect to exchange server msg")];
}

- (void)setNavBarWithType:(BKNavBarType)navBarType {
    
    switch (navBarType) {
            
        case BKNavBarTypeDefault:
        {
            UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_settings"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSettingsView)];
            UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_update"] style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
//            UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
            self.navigationItem.rightBarButtonItems = @[settingsButton, refreshButton];
            break;
        }
        default:
            break;
    }
}

#pragma mark - navigation bar actions

- (void)refresh {
    
    [BSUtilities raiseAbstractMethodExceptionForSelector:_cmd];
}

- (void)showSettingsView {
    
    [self performSegueWithIdentifier:@"Settings View Segue" sender:self];
}

@end

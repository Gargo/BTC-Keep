//
//  BKViewController.h
//  BTCKeep
//
//  Created by Vitali on 9/6/12.
//  
//

#import <UIKit/UIKit.h>
#import "BKNetworkManagerProtocol.h"

typedef enum {
    
    BKNavBarTypeDefault
} BKNavBarType;

@class BKNavController;
@class BKNetworkManagerBox;
@class BKDataManager;

@interface BKViewController : UIViewController {
    
    __weak BKNavController *navController;
    __weak BKDataManager *dataManager;
@protected
    int currentNetworkManager;
}

@property (nonatomic, retain) BKNetworkManagerBox *networkManagerBox;
@property (nonatomic, assign) BOOL shouldRefresh;

- (void)setCurrentExchangeIndex:(int)index;
- (void)showErrorConnectingToServer;
- (void)setNavBarWithType:(BKNavBarType)navBarType;

@end


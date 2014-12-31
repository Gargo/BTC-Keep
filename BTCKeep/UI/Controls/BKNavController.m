//
//  BKNavController.m
//  BK
//
//  Created by Vitali Lavrentikov on 29.08.12.
//

#import "BKNavController.h"

@implementation UIViewController(BKNavController)

- (BKNavController *)customNavigationController {
    
    return (BKNavController *)self.navigationController;
}

+ (BKNavController *)customNavigationController {
    
    return (BKNavController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
}

@end

@interface BKNavController ()

@end

@implementation BKNavController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
    
    }
    
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *controller = [super popViewControllerAnimated:animated];
    
    // Cancel performing all selectors here.
    [NSObject cancelPreviousPerformRequestsWithTarget:controller];
    
    return controller;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    
    NSArray *controllers = [super popToRootViewControllerAnimated:animated];
    
    for (UIViewController *controller in controllers) {
        
        // Cancel performing all selectors here.
        [NSObject cancelPreviousPerformRequestsWithTarget:controller];
    }
    
    return controllers;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSArray *controllers = [super popToViewController:viewController animated:animated];
    
    for (UIViewController *controller in controllers) {
        
        // Cancel performing all selectors here.
        [NSObject cancelPreviousPerformRequestsWithTarget:controller];
    }
    
    return controllers;
}


#pragma mark - Public methods


#pragma mark - Navigation

- (UIViewController *)returnToPreviousView {
	
	return [self returnToPreviousViewAnimated:YES];
}

- (UIViewController *)returnToPreviousViewAnimated:(BOOL)animated {
    
	// TODO: Some logic can be here.
    
    return [self popViewControllerAnimated:animated];
}

- (void)returnToMainViewAnimated:(BOOL)animated {
	
    if ([self.viewControllers count] > 0) {
		
		// TODO: Some logic can be here.
		
        [self popToViewController:[self.viewControllers objectAtIndex:0] animated:animated];
    }
}

- (void)showLoginView {
    
    [self showView:@"LoginViewController" animated:YES];
}

- (void)showChoiceViewFromSender:(id<BKChoiceViewControllerDelegate>)sender dataSource:(NSArray *)dataSource {
    
    BKChoiceViewController *choiceVC = [self viewControllerForName:@"BKChoiceViewController"];
    choiceVC.delegate = sender;
    choiceVC.dataSource = dataSource;
    [self pushViewController:choiceVC animated:YES];
}

#pragma mark - Private methods

- (void)showView:(NSString *)name animated:(BOOL)animated {
	
    UIViewController *controller = [[NSClassFromString(name) alloc] initWithNibName:name bundle:nil];
    [self pushViewController:controller animated:animated];
}

- (id)viewControllerForName:(NSString *)name {
    
    return [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil][0];
}

@end

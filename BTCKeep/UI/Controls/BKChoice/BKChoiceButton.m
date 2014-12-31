//
//  BKChoiceButton.m
//  BTC Keep
//
//  Created by Apple on 05.09.14.
//  
//

#import "BKChoiceButton.h"

#import "BKNavController.h"

@interface BKChoiceButton()

@property (nonatomic, strong) NSArray *tableDataSource;

@end

@implementation BKChoiceButton

@synthesize tableDataSource, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self defaultInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit {
    
    [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - public methods

- (void)setDataSource:(NSArray *)dataSource {
    
    self.tableDataSource = dataSource;
    if (dataSource.count > 0) {
        
        [self setTitle:dataSource[0] forState:UIControlStateNormal];
    } else {
        
        [self setTitle:@"" forState:UIControlStateNormal];
    }
    //Disabled/enabled state from another element which is always enabled/disabled
    if (dataSource.count > 1) {
        
        [self setTitleColor:UIColorPrimary forState:UIControlStateNormal];
        self.enabled = YES;
    } else {
        
        [self setTitleColor:UIColorDisabledDark forState:UIControlStateNormal];
        self.enabled = NO;
    }
}

#pragma mark - private methods

- (void)btnClicked:(id)sender {
    
    BKNavController *navController = [BKNavController customNavigationController];
    [navController showChoiceViewFromSender:self dataSource:tableDataSource];
}

#pragma mark - BKChoiceViewControllerDelegate methods

- (void)choiceSender:(BKChoiceViewController *)sender chosenIndex:(int)index chosenObject:(id)obj {
    
    [self setTitle:obj forState:UIControlStateNormal];
    [delegate choiceSender:self chosenIndex:index chosenObject:obj];
}

#pragma mark - memory management

- (void)dealloc {
    
    [self removeTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

@end

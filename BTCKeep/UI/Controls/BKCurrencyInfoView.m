//
//  BKCurrencyInfoView.m
//  BTCKeep
//
//  Created by Iryna on 5/7/14.
//  
//

#import "BKCurrencyInfoView.h"

#import "BKTradePair.h"
#import "BKTrade.h"
#import "BKDataManager.h"


@interface BKCurrencyInfoView()

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end


@implementation BKCurrencyInfoView

@synthesize view;
@synthesize delegate;
@synthesize txtView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self defaultInit];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self defaultInit];
}

#pragma mark - Public methods

- (void)setTradePair:(BKTradePair *)tradePair {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    
    txtView.text = [NSString stringWithFormat:@" Last price = %@ \n Volume = %@ \n Market volume = %@ \n 24h min price = %@ \n 24h max price = %@", [BSUtilities stringWithNumberPrice:tradePair.lastRate], tradePair.currencyVolume, tradePair.marketVolume, [BSUtilities stringWithNumberPrice:tradePair.minRate], [BSUtilities stringWithNumberPrice:tradePair.maxRate]];
    txtView.attributedText = [[NSAttributedString alloc] initWithString:txtView.text attributes:@{NSParagraphStyleAttributeName : style}];
    [txtView setTextColor:[UIColor whiteColor]];
    
    [txtView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

#pragma mark - Private methods

- (void)defaultInit {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:view];
    view.frame = self.bounds;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    UITextView *txtview = object;
    CGFloat topoffset = ([txtview.superview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
    
    self.topConstraint.constant = topoffset;
}

#pragma mark - Actions methods

- (IBAction)onCalculatorBtn:(id)sender {
    
    [delegate currencyInfoViewWillShowCalculatorView];
}

#pragma mark - memory management

- (void)dealloc {
    
    [txtView removeObserver:self forKeyPath:@"contentSize"];
}

@end

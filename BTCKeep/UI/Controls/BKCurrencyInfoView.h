//
//  BKCurrencyInfoView.h
//  BTCKeep
//
//  Created by Iryna on 5/7/14.
//  
//

#import <UIKit/UIKit.h>


@class BKTradePair;

@protocol BKCurrencyInfoViewDelegate <NSObject>

- (void)currencyInfoViewWillShowCalculatorView;

@end


@interface BKCurrencyInfoView : UIView

@property (nonatomic, weak) id<BKCurrencyInfoViewDelegate> delegate;

- (void)setTradePair:(BKTradePair *)tradePair;

@end

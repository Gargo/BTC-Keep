//
//  BKGraphView.h
//  BTC Keep
//
//  Created by Apple on 27.07.14.
//  
//

#import <UIKit/UIKit.h>

typedef enum {

    BKGraphViewZoomTypeMonths,
    BKGraphViewZoomTypeDays6,
    BKGraphViewZoomTypeDays,
    BKGraphViewZoomTypeHours2,
    BKGraphViewZoomTypeHours
} BKGraphViewZoomType;

@protocol BKGraphViewDelegate

- (void)graphTouched:(id)sender;

@end

@interface BKGraphView : UIView <CPTPlotDataSource, CPTAxisDelegate, CPTPlotSpaceDelegate>

@property (nonatomic, assign) id<BKGraphViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *xValues; //createdAt
@property (nonatomic, strong) NSMutableArray *yValues; //rate * multiplier
@property (nonatomic, assign, setter = setGestureRecognizers:) BOOL gesturesEnabled;
@property (assign) BKGraphViewZoomType zoomType;
@property (nonatomic, assign) BOOL isXAxisMax;
@property (nonatomic, assign) CPTXYAxisSet *axisSet;
@property (nonatomic, assign) double previousDY;
@property (nonatomic, assign) double firstYMiddleInterval;

- (void)resetWithTrades:(NSArray *)trades;
- (void)setRotationInLandscapeMode:(BOOL)status;

@end

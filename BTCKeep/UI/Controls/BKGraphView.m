//
//  BKGraphView.m
//  BTC Keep
//
//  Created by Apple on 27.07.14.
//  
//

#import "BKGraphView.h"
#import "BKTrade.h"
#import "BKDataManager.h"

#define BKPlotIdentifier    @"plot identifier"
#define BKPlotMinDYCount    5
#define BKPlotMaxDYCount    9

@interface BKGraphView()

@property (nonatomic, strong) CPTGraphHostingView *hostView;

@end

@implementation BKGraphView

@synthesize hostView, xValues, yValues, delegate, gesturesEnabled, zoomType, isXAxisMax, previousDY, axisSet, firstYMiddleInterval;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        
    }
    return self;
}

#pragma mark - public methods

- (void)resetWithTrades:(NSArray *)trades {
    
    self.xValues = [NSMutableArray array];
    self.yValues = [NSMutableArray array];
    for (BKTrade *tr in trades) {
        
        [xValues addObject:tr.createdAt];
        [yValues addObject:tr.rate];
    }
    
    double min_price = [yValues.lastObject doubleValue];
    double max_price = -1;
    for (NSString *rateString in yValues) {
        
        double rate = [rateString doubleValue];
        if (rate < min_price) {
            
            min_price = rate;
        }
        if (rate > max_price) {
            
            max_price = rate;
        }
    }
    double priceRange = max_price - min_price;
    previousDY = priceRange * BKPlotValueMultiplier / BKPlotMinDYCount;
    firstYMiddleInterval = (min_price + priceRange / 2) * BKPlotValueMultiplier;
    
    [self initPlot];
}

- (void)setRotationInLandscapeMode:(BOOL)status {
    
//    if(status) {
//        
//        self.hostView.transform = CGAffineTransformMakeRotation((M_PI * (90) / 180.0));
//        self.hostView.frame = self.bounds;
//    } else {
//        
//        self.hostView.transform = CGAffineTransformMakeRotation((0));
//        self.hostView.frame = self.bounds;
//    }
}

- (void)setGesturesEnabled:(BOOL)areGesturesEnabled {
    
    self.gesturesEnabled = areGesturesEnabled;
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = areGesturesEnabled;
}

#pragma mark - private methods

- (void)initPlot {
    
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

#pragma mark - private methods

-(void)configureHost {
    
    [hostView removeFromSuperview];
    self.hostView = (CPTGraphHostingView *)[[CPTGraphHostingView alloc] initWithFrame:CGRectMake(-16, 0, self.bounds.size.width + 24, self.bounds.size.height)];
    hostView.allowPinchScaling = YES;
    [self addSubview:hostView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [hostView addGestureRecognizer:tapGR];
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    
    [delegate graphTouched:self];
}

-(void)configureGraph {
    
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    
    // 2 - Set graph title
    graph.title = BKLocalizedString(@"Trades title");
    graph.plotAreaFrame.borderLineStyle = nil;
    
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica Neue";
    titleStyle.fontSize = 17.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    if (isiPhone5) {
        
        graph.titleDisplacement = CGPointMake(0, 6);
    } else {
        
        graph.titleDisplacement = CGPointMake(0, 11);
    }
    graph.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0 green:185 / 255.0 blue:237 / 255.0 alpha:1]];
    
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:0.0f];
    [graph.plotAreaFrame setPaddingBottom:20.0f];
    [graph.plotAreaFrame setPaddingTop:10.0f];
    [graph.plotAreaFrame setFill:[CPTFill fillWithColor:[CPTColor colorWithCGColor:UIColorFromRGB(0, 185, 237).CGColor]]];
    
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
        plotSpace.delegate = self;
    plotSpace.allowsUserInteraction = gesturesEnabled;
}

-(void)configurePlots {
    
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    // 2 - Create the plot
    CPTScatterPlot *aPlot = [[CPTScatterPlot alloc] init];
    aPlot.dataSource = self;
    aPlot.identifier = BKPlotIdentifier;
    CPTColor *aColor = [CPTColor whiteColor];
    [graph addPlot:aPlot toPlotSpace:plotSpace];
    
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObject:aPlot]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    if (xValues.count) {
        
        [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.4f)];
        
        CGFloat loc_min = [xValues[0] timeIntervalSince1970];
        CGFloat loc_max = [xValues.lastObject timeIntervalSince1970];
        xRange.location = [[NSDecimalNumber numberWithDouble:loc_min - 0.35 * (loc_max - loc_min)] decimalValue];
        //xRange.location = [[NSDecimalNumber numberWithDouble:1394209784 - 2200000] decimalValue];
    }
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.3f)];
    plotSpace.yRange = yRange;
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *aLineStyle = [aPlot.dataLineStyle mutableCopy];
    aLineStyle.lineWidth = 1.7;
    aLineStyle.lineColor = aColor;
    aPlot.dataLineStyle = aLineStyle;
    CPTMutableLineStyle *aSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    aSymbolLineStyle.lineColor = aColor;
    CPTPlotSymbol *aSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    aSymbol.fill = [CPTFill fillWithColor:aColor];
    aSymbol.lineStyle = aSymbolLineStyle;
    aSymbol.size = CGSizeMake(4.0f, 4.0f);
    //    aPlot.plotSymbol = aSymbol;
}

-(void)configureAxes {
    
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 0.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *xAxisTextStyle = [[CPTMutableTextStyle alloc] init];
    xAxisTextStyle.color = [CPTColor whiteColor];
    xAxisTextStyle.fontName = @"Helvetica";
    xAxisTextStyle.fontSize = 11.0f;
    CPTMutableTextStyle *yAxisTextStyle = [[CPTMutableTextStyle alloc] init];
    yAxisTextStyle.color = [CPTColor whiteColor];
    yAxisTextStyle.fontName = @"Helvetica";
    yAxisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor colorWithCGColor:UIColorPrimary.CGColor];
    gridLineStyle.lineWidth = 0.3f;
    
    // 2 - Get axis set
    self.axisSet = (CPTXYAxisSet *)self.hostView.hostedGraph.axisSet;
    axisSet.xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:62.0];
    
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.delegate = self;
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = xAxisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.delegate = self;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = yAxisTextStyle;
    y.labelOffset = 58.0f;
    y.labelAlignment = CPTAlignmentMiddle;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 0.4f;
    y.minorTickLength = 0.2f;
    y.tickDirection = CPTSignPositive;
    
//    //remove later
//    {
//        double min_price = [yValues.lastObject doubleValue];
//        double max_price = -1;
//        for (NSString *rateString in yValues) {
//            
//            double rate = [rateString doubleValue];
//            if (rate < min_price) {
//                
//                min_price = rate;
//            }
//            if (rate > max_price) {
//                
//                max_price = rate;
//            }
//        }
//        double price_range = max_price - min_price;
//        
//        NSMutableSet *yLabels = [NSMutableSet set];
//        NSMutableSet *yMajorLocations = [NSMutableSet set];
//        
//        // major locations
//        int lineCount = 5;
//        for (int i = 0; i < lineCount; i++) {
//            
//            double value;
//            if (price_range > 0.000000045)
//                value = min_price + price_range * i / ((double)lineCount - 1);
//            else
//                value = min_price + 0.00000001 * i;
//            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%.08lf", value] textStyle:y.labelTextStyle];
//            value *= BKPlotValueMultiplier;
//            NSDecimal location = CPTDecimalFromDouble(value);
//            label.tickLocation = location;
//            label.offset = -y.majorTickLength - y.labelOffset;
//            if (label) {
//                
//                [yLabels addObject:label];
//            }
//            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
//            
//            // price_range == 0 is meant
//            if (price_range < 0.000000000001)
//                break;
//        }
//        
//        y.axisLabels = yLabels;
//        y.majorTickLocations = yMajorLocations;
//    }
}

- (NSDate *)dateForDateString:(NSString *)tradeCreation {
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", [tradeCreation substringToIndex:10], [tradeCreation substringWithRange:NSMakeRange(11, 8)]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:BKCommonDateFormat];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    return xValues.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    switch (fieldEnum) {
            
        case CPTScatterPlotFieldX:
        {
            return [NSDecimalNumber numberWithDouble:[xValues[index] timeIntervalSince1970]];
            break;
        }
        case CPTScatterPlotFieldY:
        {
            return [NSNumber numberWithDouble:[yValues[index] doubleValue] * BKPlotValueMultiplier];
            break;
        }
    }
    return [NSDecimalNumber zero];
}

#pragma mark - CPTAxisDelegate methods

- (BOOL)axisShouldRelabel:(CPTAxis *)axis {
    
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    if ([axis isEqual:axisSet.xAxis]) {
        
        //Find an appropriate visible label count
        NSTimeInterval startInterval = plotSpace.xRange.locationDouble;
        NSTimeInterval endInterval = startInterval + plotSpace.xRange.lengthDouble;
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startInterval];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit)
                                               fromDate:startDate
                                                 toDate:endDate
                                                options:0];
        int months = [comps month];
        int days = [comps day];
        int hours = [comps hour];
        BKGraphViewZoomType tempZoomType = BKGraphViewZoomTypeMonths;
        if (months == 0) {
            
            tempZoomType = BKGraphViewZoomTypeDays6;
            if (days < 6) {
                
                tempZoomType = BKGraphViewZoomTypeDays;
                if (days == 0) {
                    
                    tempZoomType = BKGraphViewZoomTypeHours2;
                    if (hours < 12) {
                        
                        tempZoomType = BKGraphViewZoomTypeHours;
                    }
                }
            }
        }
        self.zoomType = tempZoomType;
        
        
        CPTAxis *x = axis;
        NSMutableSet *xLabels = [NSMutableSet set];
        NSMutableSet *xLocations = [NSMutableSet set];
        if (xValues.count > 0) {
            
            NSMutableArray *labelTextArr = [NSMutableArray array];
            NSMutableArray *labelPositionArr = [NSMutableArray array];
            NSDate *date1Border = [NSDate dateWithTimeIntervalSince1970:startInterval];
            NSDate *date2Border = [NSDate dateWithTimeIntervalSince1970:endInterval];
            if (zoomType == BKGraphViewZoomTypeMonths) {
                
                NSDate *date1 = [BSUtilities dateByRoundingDate:date1Border toLowerUnit:NSCalendarUnitYear];
                NSDate *date2 = [BSUtilities dateByRoundingDate:date2Border toHigherUnit:NSCalendarUnitYear];
                int createdAt1 = [date1 timeIntervalSince1970];
                int createdAt2 = [date2 timeIntervalSince1970];
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *comps = [gregorian components:(NSMonthCalendarUnit)
                                                       fromDate:date1
                                                         toDate:date2
                                                        options:0];
                int labelCount = [comps month] + 1;
                int dCreatedAt = (labelCount > 1) ? (createdAt2 - createdAt1) / (labelCount - 1) : 0;
                for (int i = 0; i < labelCount; i++) {
                    
                    int currentCreatedAt = createdAt1 + dCreatedAt * i;
                    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentCreatedAt];
                    [labelTextArr addObject:[BSUtilities stringWithMonthFromDate:currentDate]];
                    [labelPositionArr addObject:@(currentCreatedAt)];
                }
            } else if ((zoomType == BKGraphViewZoomTypeDays) || (zoomType == BKGraphViewZoomTypeDays6)) {
                
                NSDate *date1 = [BSUtilities dateByRoundingDate:date1Border toLowerUnit:NSCalendarUnitMonth];
                NSDate *date2 = [BSUtilities dateByRoundingDate:date2Border toHigherUnit:NSCalendarUnitMonth];
                int createdAt1 = [date1 timeIntervalSince1970];
                int createdAt2 = [date2 timeIntervalSince1970];
                int days = (createdAt2 - createdAt1) / 86400;
                if (zoomType == BKGraphViewZoomTypeDays6) {
                    
                    days /= 5;
                }
                int labelCount = days + 1;
                int dCreatedAt = (labelCount > 1) ? (createdAt2 - createdAt1) / (labelCount - 1) : 0;
                for (int i = 0; i < labelCount - 1; i++) {
                    
                    int currentCreatedAt = createdAt1 + dCreatedAt * i;
                    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentCreatedAt];
                    [labelTextArr addObject:[BSUtilities stringWithMonthDayFromDate:currentDate]];
                    [labelPositionArr addObject:@(currentCreatedAt)];
                }
                {
                    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:createdAt2];
                    [labelTextArr addObject:[BSUtilities stringWithMonthDayFromDate:currentDate]];
                    [labelPositionArr addObject:@(createdAt2)];
                }
            } else if ((zoomType == BKGraphViewZoomTypeHours) || (zoomType == BKGraphViewZoomTypeHours2)) {
                
                NSDate *date1 = [BSUtilities dateByRoundingDate:date1Border toLowerUnit:NSCalendarUnitDay];
                NSDate *date2 = [BSUtilities dateByRoundingDate:date2Border toHigherUnit:NSCalendarUnitDay];
                int createdAt1 = [date1 timeIntervalSince1970];
                int createdAt2 = [date2 timeIntervalSince1970];
                int hours = (createdAt2 - createdAt1) / 3600;
                int monthLabelStep = 24;
                if (zoomType == BKGraphViewZoomTypeHours2) {
                    
                    hours /= 2;
                    monthLabelStep = 12;
                }
                int labelCount = hours + 1;
                if (labelCount <= 1) {
                    
                    return NO;
                }
                int dCreatedAt = (labelCount > 1) ? (createdAt2 - createdAt1) / (labelCount - 1) : 0;
                for (int i = 0; i < labelCount; i++) {
                    
                    int currentCreatedAt = createdAt1 + dCreatedAt * i;
                    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentCreatedAt];
                    if (i % monthLabelStep > 0) {
                        
                        [labelTextArr addObject:[BSUtilities stringWithHourFromDate:currentDate]];
                    } else {
                        
                        [labelTextArr addObject:[BSUtilities stringWithMonthDayFromDate:currentDate]];
                    }
                    [labelPositionArr addObject:@(currentCreatedAt)];
                }
            }
            
            for (int i = 0; i < labelTextArr.count; i++) {
                
                CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:labelTextArr[i] textStyle:x.labelTextStyle];
                label.tickLocation = CPTDecimalFromDouble([labelPositionArr[i] doubleValue]);
                label.offset = x.majorTickLength;
                if (label) {
                    
                    [xLabels addObject:label];
                    [xLocations addObject:labelPositionArr[i]];
                }
            }
        }
        x.axisLabels = xLabels;
        x.majorTickLocations = xLocations;
    } else {
        
        //y axis
        CPTAxis *y = axis;
        double currentMiddleInterval = plotSpace.yRange.locationDouble + plotSpace.yRange.lengthDouble / 2;
        double labelingMiddleInterval = firstYMiddleInterval;
        int lineCount = plotSpace.yRange.lengthDouble / previousDY;
        
        if (previousDY > 0) {
            
            labelingMiddleInterval = floor(currentMiddleInterval / previousDY) * previousDY;
            while (lineCount > BKPlotMaxDYCount) {
                
                previousDY *= 2;
                lineCount = plotSpace.yRange.lengthDouble / previousDY;
            }
            while (lineCount < BKPlotMinDYCount) {
                
                previousDY /= 2;
                lineCount = plotSpace.yRange.lengthDouble / previousDY;
            }
        }
        
        // major locations
        NSMutableSet *yLabels = [NSMutableSet set];
        NSMutableSet *yLocations = [NSMutableSet set];
        
        for (int i = -lineCount / 2; i <= lineCount / 2; i++) {
            
            double value;
            value = labelingMiddleInterval + previousDY * i;
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%.08lf", value / BKPlotValueMultiplier] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromDouble(value);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                
                [yLabels addObject:label];
            }
            [yLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        }
        
        y.axisLabels = yLabels;
        y.majorTickLocations = yLocations;
    }
    return YES;
}

#pragma mark - CPTPlotSpaceDelegate methods

- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate {
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)space;
    if (coordinate != CPTCoordinateX) {
        
        if (isXAxisMax) {
            
            return plotSpace.yRange;
        } else {
            
            return newRange;
        }
    }
    NSTimeInterval startInterval = newRange.locationDouble;
    NSTimeInterval endInterval = startInterval + newRange.lengthDouble;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startInterval];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit
                                           fromDate:startDate
                                             toDate:endDate
                                            options:0];
    if ([comps year] > 0) {
        
        isXAxisMax = YES;
        return plotSpace.xRange;
    } else {
        
        isXAxisMax = NO;
        return newRange;
    }
}

//-(void)plotSpace:(CPTPlotSpace *)space didChangePlotRangeForCoordinate:(CPTCoordinate)coordinate {
//    
//    
//    
////    NSLog(@"%.0lf, %.0lf", [[NSDecimalNumber decimalNumberWithDecimal:plotSpace.xRange.location] doubleValue], [[NSDecimalNumber decimalNumberWithDecimal:plotSpace.xRange.length] doubleValue]);
//}

@end

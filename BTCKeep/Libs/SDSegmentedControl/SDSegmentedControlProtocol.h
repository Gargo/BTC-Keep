//
//  SDSegmentedControlProtocol.h
//  BTCKeep
//
//  Created by Iryna on 5/19/14.
//  
//

#import <Foundation/Foundation.h>

@class SDSegmentedControl;

@protocol SDSegmentedControlDelegate <NSObject>

- (void)segmentedControl:(SDSegmentedControl *)segmentedControl didSelectItemAtIndex:(NSInteger)index;

@end

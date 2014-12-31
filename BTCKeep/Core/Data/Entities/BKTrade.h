//
//  BKTrade.h
//  BTC Keep
//
//  Created by Vyachaslav on 20.10.14.
//  
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BKBase.h"


@interface BKTrade : BKBase

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isBid;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * tradePairId;

@end

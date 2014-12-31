//
//  BKTradePair.h
//  BTC Keep
//
//  Created by Vyachaslav on 20.10.14.
//  
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BKBase.h"


@interface BKTradePair : BKBase

@property (nonatomic, retain) NSNumber * currencyVolume;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * lastRate;
@property (nonatomic, retain) NSNumber * marketVolume;
@property (nonatomic, retain) NSNumber * maxRate;
@property (nonatomic, retain) NSNumber * minRate;
@property (nonatomic, retain) NSString * primaryCurrencyId;
@property (nonatomic, retain) NSString * secondaryCurrencyId;

@end

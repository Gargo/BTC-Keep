//
//  BKCurrency.h
//  BTC Keep
//
//  Created by Vyachaslav on 20.10.14.
//  
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BKBase.h"


@interface BKCurrency : BKBase

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;

@end

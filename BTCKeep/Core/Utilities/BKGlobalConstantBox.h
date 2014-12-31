//
//  BKGlobalConstantBox.h
//  BTCKeep
//
//  Created by Apple on 28.05.14.
//  
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]

#define UIColorPrimary UIColorFromRGB(0, 155, 206)
#define UIColorDisabledDark UIColorFromRGB(111, 113, 121)

#define isiPhone5  (([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE)

#define BKMaxPriceStringLength          20

//Segue identifiers
#define BKSegueIdUnwindToMainView       @"Unwind To Main View Segue"
#define BKSegueIdUnwindToCalculatorView @"Unwind To Calculator View Segue"

//multiply all the values on plot to prevent graphic bugs
#define BKPlotValueMultiplier   100000000
#define BKAccuracyLimit         0.00000001

#define BKCommonDateFormat  @"yyyy-MM-dd HH:mm:ss"

#define BKTimeoutInterval   20

//blocks
#define BKVoidBlock void(^)()
typedef void (^BKVoidBlockFromIDObject)(id);

@interface BKGlobalConstantBox : NSObject

+ (BKGlobalConstantBox *)sharedInstance;

@end

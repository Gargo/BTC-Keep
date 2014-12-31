//
//  BSUtilities.h
//
//  Created by Vitali on 8/13/12.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#define BKNotificationKeyIsSuccess  @"isSuccess"

@class BKNetworkManager;

@interface BSUtilities : NSObject

+ (NSString *)safelyGetString:(NSDictionary *)json forKey:(NSString *)key;
+ (NSNumber *)safelyGetNumber:(NSDictionary *)dict forKey:(NSString *)key;
+ (NSArray *)safelyGetArray:(NSDictionary *)json forKey:(NSString *)key;
+ (NSDictionary *)safelyGetDictionary:(NSDictionary *)json forKey:(NSString *)key;

+ (NSString *)safelyGetString:(NSArray *)json atIndex:(int)index;
+ (NSNumber *)safelyGetNumber:(NSArray *)json atIndex:(int)index;

+ (NSString*)escapeTextForXml:(NSString*)text;

+ (BOOL)validateEmail:(NSString*)email;

+ (NSArray *)abc;

+ (NSString *)commonStringFromDate:(NSDate *)date;
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)stringFormat;

+ (NSArray *)arrayWithSelector:(SEL)selector1;
+ (NSArray *)arrayWithSelectors:(SEL)selector1, ...;

+ (NSString *)operationIdentifierWithURLString:(NSString *)URLString params:(NSDictionary *)params;
+ (NSString *)operationIdentifierWithURLStrings:(NSArray *)URLStrings params:(NSArray *)params;

+ (NSArray *)exchangeTitlesForNetworkManagers:(NSArray *)networkManagers;
+ (int)exchangeIDForExchange:(id)exchange;
+ (NSNumber *)exchangeNumberForExchange:(id)exchange;

+ (NSString *)stringWithNumberPrice:(NSNumber *)price;
+ (NSString *)stringWithPrice:(double)price;

+ (NSString *)requestStringFromParams:(NSDictionary *)params;

+ (NSString *)stringWithContentsOfURLString:(NSString *)str error:(NSError **)error;

//NSDate
+ (NSDate *)dateByRoundingDate:(NSDate *)date toLowerUnit:(NSCalendarUnit)unit;
+ (NSDate *)dateByRoundingDate:(NSDate *)date toHigherUnit:(NSCalendarUnit)unit; //lower + 1 day
+ (NSString *)stringWithMonthFromDate:(NSDate *)date;
+ (NSString *)stringWithMonthDayFromDate:(NSDate *)date;
+ (NSString *)stringWithHourFromDate:(NSDate *)date;

//Predicates
+ (NSPredicate *)predicateforExchange:(id)exchange;
+ (NSPredicate *)predicateWithDictionary:(NSDictionary *)dict forExchange:(id)exchange;

//Exceptions
+ (void)raiseAbstractMethodExceptionForSelector:(SEL)methodSelector;
+ (void)raiseForbiddenMethodExceptionForSelector:(SEL)methodSelector substitutiveSelector:(SEL)substitutiveSelector;

//GCD
+ (dispatch_queue_t)globalQueue;
+ (dispatch_queue_t)mainQueue;

//Notifications
+ (void)sendNetworkNotificationNamed:(NSString *)name isSuccessful:(BOOL)isSuccessful;
+ (BOOL)isNetworkNotificationSuccessful:(NSNotification *)notification;

//Encoding
+ (NSString *)sha512:(NSString *)input withSalt:(NSString *)salt;
+ (NSString *)base64EncodeString:(NSString *)strData;
+ (NSString *)base64EncodeData:(NSData *)objData;
+ (NSData *)base64DecodeString:(NSString *)strBase64;

//Visual
+ (void)showWarningWithText:(NSString *)warningText;
+ (void)showErrorWithText:(NSString *)warningText;
+ (void)showResponseErrorForNetworkManager:(BKNetworkManager *)manager;
+ (void)fillView:(UIView *)v withPatternImageNamed:(NSString *)imgName;
+ (UITableView *)parentTableForView:(UIView *)view;
+ (UITableViewCell *)parentCellForView:(UIView *)view;

@end

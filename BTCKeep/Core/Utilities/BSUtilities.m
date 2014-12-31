//
//  BSUtilities.m
//
//  Created by Vitali on 8/13/12.
//
//

#import "BSUtilities.h"
#import "BKNetworkManager.h"

//data adapters
#import "BKDataAdapterBitstamp.h"
#import "BKDataAdapterCoins_E.h"
#import "BKDataAdapterCryptsy.h"
#import "BKDataAdapterLocalBitcoins.h"
#import "BKDataAdapterC_Cex.h"
#import "BKDataAdapterBter.h"

//network managers
#import "BKNetworkManagerBitstamp.h"
#import "BKNetworkManagerCoins_E.h"
#import "BKNetworkManagerCryptsy.h"
#import "BKNetworkManagerLocalBitcoins.h"
#import "BKNetworkManagerC_Cex.h"
#import "BKNetworkManagerBter.h"

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
	-2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
	-2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@implementation BSUtilities


+ (NSString *)safelyGetString:(NSDictionary *)json forKey:(NSString *)key {
    
    id value = [json objectForKey:key];
    
    return [value isKindOfClass:[NSString class]] ? value : ([value isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@", value] : @"");
}

+ (NSNumber *)safelyGetNumber:(NSDictionary *)json forKey:(NSString *)key {
    
    id value = [json objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        
        return value;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        NSNumber *number = [formatter numberFromString:value];
        
        return number;
    }
    
    return nil;
}

+ (NSArray *)safelyGetArray:(NSDictionary *)json forKey:(NSString *)key {
    
    id value = [json objectForKey:key];
    
    return [value isKindOfClass:[NSArray class]] ? value : [NSArray array];
}

+ (NSDictionary *)safelyGetDictionary:(NSDictionary *)json forKey:(NSString *)key {
    
    id value = [json objectForKey:key];
    
    return [value isKindOfClass:[NSDictionary class]] ? value : [NSDictionary dictionary];
}

+ (NSString *)safelyGetString:(NSArray *)json atIndex:(int)index {
    
    if ([json count] > index)
    {
        id value = [json objectAtIndex:index];
        
        return [value isKindOfClass:[NSString class]] ? value : ([value isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@", value] : @"");
    }
    
    return @"";
}

+ (NSNumber *)safelyGetNumber:(NSArray *)json atIndex:(int)index {
    
    if ([json count] > index)
    {
        id value = [json objectAtIndex:index];
        
        if ([value isKindOfClass:[NSNumber class]]) {
            
            return value;
        }
        else if ([value isKindOfClass:[NSString class]]) {
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            NSNumber *number = [formatter numberFromString:value];
            
            return number;
        }
        
        return nil;
    }
    
    return nil;
}


+ (NSString*)escapeTextForXml:(NSString*)text {
    
    text = [text stringByReplacingOccurrencesOfString: @"&" withString:@"&amp;"];
    text = [text stringByReplacingOccurrencesOfString: @"<" withString:@"&lt;"];
    text = [text stringByReplacingOccurrencesOfString: @">" withString:@"&gt;"];
    text = [text stringByReplacingOccurrencesOfString: @"\"" withString:@"&quot;"];
    text = [text stringByReplacingOccurrencesOfString: @"'" withString:@"&apos;"];

    return text;
}


+ (BOOL)validateEmail:(NSString*)email {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    return [predicate evaluateWithObject:email];
}


+ (NSArray *)abc {
    
    static NSArray *abcArray = nil;
    if (!abcArray) {
        
        abcArray = [NSArray arrayWithObjects:@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
    return abcArray;
}

+ (NSString *)commonStringFromDate:(NSDate *)date {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    [formatter setDateFormat:BKCommonDateFormat];
    return [formatter stringFromDate:date];
}

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)stringFormat {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    [formatter setDateFormat:stringFormat];
    return formatter;
}

+ (NSArray *)arrayWithSelector:(SEL)selector1 {
    
    return [self arrayWithSelectors:selector1, nil];
}

+ (NSArray *)arrayWithSelectors:(SEL)selector1, ... {
    
    NSMutableArray *arr = [NSMutableArray array];
    SEL eachObject;
    va_list argumentList;
    if (selector1) {
        
        [arr addObject:NSStringFromSelector(selector1)];
        va_start(argumentList, selector1);
        while ((eachObject = va_arg(argumentList, SEL))) {
            
            [arr addObject:NSStringFromSelector(eachObject)];
        }
        va_end(argumentList);
    }
    return arr;
}

+ (NSString *)operationIdentifierWithURLString:(NSString *)URLString params:(NSDictionary *)params {
    
    NSMutableString *str = [NSMutableString stringWithString:URLString];
    for (NSString *key in params) {
        
        [str appendString:key];
    }
    return str;
}

+ (NSString *)operationIdentifierWithURLStrings:(NSArray *)URLStrings params:(NSArray *)params {
    
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < URLStrings.count; i++) {
        
        NSDictionary *currentParams = params[i];
        if ([currentParams isKindOfClass:[NSNull class]]) {
            
            currentParams = nil;
        }
        [str appendString:[self operationIdentifierWithURLString:URLStrings[i] params:currentParams]];
    }
    return str;
}

+ (void)raiseAbstractMethodExceptionForSelector:(SEL)methodSelector {
    
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override (%@) in a subclass", NSStringFromSelector(methodSelector)];
}

+ (void)raiseForbiddenMethodExceptionForSelector:(SEL)methodSelector substitutiveSelector:(SEL)substitutiveSelector {
    
    [NSException raise:NSInternalInconsistencyException
                format:@"You called (%@). You should use (%@) instead", NSStringFromSelector(methodSelector), NSStringFromSelector(substitutiveSelector)];
}

+ (NSArray *)exchangeTitlesForNetworkManagers:(NSArray *)networkManagers {
    
    NSMutableArray *exchangeTitles = [NSMutableArray array];
    for (BKNetworkManager *nm in networkManagers) {
        
        [exchangeTitles addObject:[nm exchangeName]];
    }
    return exchangeTitles;
}

+ (int)exchangeIDForExchange:(id)exchange {
    
    typedef enum {
        
        BKExchangeBitstamp,
        BKExchangeCoins_E,
        BKExchangeCryptsy,
        BKExchangeC_Cex,
        BKExchangeLocalBitcoins,
        BKExchangeBter
    } BKExchange;
    
    if ([exchange isKindOfClass:[BKDataAdapterBitstamp class]] || [exchange isKindOfClass:[BKNetworkManagerBitstamp class]]) {
        
        return BKExchangeBitstamp;
    } else if ([exchange isKindOfClass:[BKDataAdapterCoins_E class]] || [exchange isKindOfClass:[BKNetworkManagerCoins_E class]]) {
        
        return BKExchangeCoins_E;
    } else if ([exchange isKindOfClass:[BKDataAdapterCryptsy class]] || [exchange isKindOfClass:[BKNetworkManagerCryptsy class]]) {
        
        return BKExchangeCryptsy;
    } else if ([exchange isKindOfClass:[BKDataAdapterLocalBitcoins class]] || [exchange isKindOfClass:[BKNetworkManagerLocalBitcoins class]]) {
        
        return BKExchangeLocalBitcoins;
    } else if ([exchange isKindOfClass:[BKDataAdapterC_Cex class]] || [exchange isKindOfClass:[BKNetworkManagerC_Cex class]]) {
        
        return BKExchangeLocalBitcoins;
    } else if ([exchange isKindOfClass:[BKDataAdapterBter class]] || [exchange isKindOfClass:[BKNetworkManagerBter class]]) {
        
        return BKExchangeBter;
    }
    return -1;
}

+ (NSNumber *)exchangeNumberForExchange:(id)exchange {
    
    return @([self exchangeIDForExchange:exchange]);
}

+ (NSString *)stringWithNumberPrice:(NSNumber *)price {
    
    return [self stringWithPrice:[price doubleValue]];
}

+ (NSString *)stringWithPrice:(double)price {
    
    return [NSString stringWithFormat:@"%.8f", price];
}

+ (NSString *)requestStringFromParams:(NSDictionary *)params {
    
    NSMutableString *result = [NSMutableString string];
    for (NSString *key in params) {
        
        [result appendFormat:@"&%@=%@", key, params[key]];
    }
    if (result.length > 0) {
        
        return [result substringFromIndex:1];
    } else {
        
        return nil;
    }
}

+ (NSString *)stringWithContentsOfURLString:(NSString *)str error:(NSError **)error {
    
    return [NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:NSUTF8StringEncoding error:error];
}

+ (NSDate *)dateByRoundingDate:(NSDate *)date toLowerUnit:(NSCalendarUnit)unit {
    
    if (date == nil) {
        
        date = [NSDate date];
    }
    NSCalendarUnit calendarComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    if (unit != NSCalendarUnitDay) {
        
        calendarComponents ^= NSCalendarUnitDay;
        if (unit != NSCalendarUnitMonth) {
            
            calendarComponents ^= NSCalendarUnitMonth;
        }
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:calendarComponents fromDate:date];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)dateByRoundingDate:(NSDate *)date toHigherUnit:(NSCalendarUnit)unit {

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    switch (unit) {
            
        case NSCalendarUnitDay:
            [offsetComponents setDay:1];
            break;
        case NSCalendarUnitMonth:
            [offsetComponents setMonth:1];
            break;
        default:
            [offsetComponents setYear:1];
            break;
    }
    NSDate *date2 = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    return [self dateByRoundingDate:date2 toLowerUnit:unit];
}

+ (NSString *)stringWithMonthFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [self dateFormatterWithFormat:@"MMM"];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringWithMonthDayFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [self dateFormatterWithFormat:@"dd MMM"];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringWithHourFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [self dateFormatterWithFormat:@"H'h'"];
    return [formatter stringFromDate:date];
}

+ (NSPredicate *)predicateforExchange:(id)exchange {
    
    return [self predicateWithDictionary:nil forExchange:exchange];
}

+ (NSPredicate *)predicateWithDictionary:(NSDictionary *)dict forExchange:(id)exchange {
    
    NSMutableString *predicateFormat = [NSMutableString string];
    for (int i = 0; i < dict.allKeys.count + 1; i++) {
        
        [predicateFormat appendString:@"AND (%K = %@)"];
    }
    [predicateFormat deleteCharactersInRange:NSMakeRange(0, 4)];
    NSMutableArray *mixedParams = [NSMutableArray array];
    for (NSString *key in dict) {
        
        [mixedParams addObject:key];
        [mixedParams addObject:dict[key]];
    }
    [mixedParams addObject:BKKeyExchangeID];
    [mixedParams addObject:[BSUtilities exchangeNumberForExchange:exchange]];
    return [NSPredicate predicateWithFormat:predicateFormat argumentArray:mixedParams];
}

+ (dispatch_queue_t)globalQueue {
    
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

+ (dispatch_queue_t)mainQueue {
    
    return dispatch_get_main_queue();
}

+ (void)sendNetworkNotificationNamed:(NSString *)name isSuccessful:(BOOL)isSuccessful {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:@{BKNotificationKeyIsSuccess : @(isSuccessful)}];
}

+ (BOOL)isNetworkNotificationSuccessful:(NSNotification *)notification {
    
    return [notification.userInfo[BKNotificationKeyIsSuccess] boolValue];
}

+ (NSString *)sha512:(NSString *)input withSalt:(NSString *)salt {
    
    const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    const char *data = [input cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), data, strlen(data), digest);
    
    NSString *hash;
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    hash = output;
    return hash;
}

+ (NSString *) base64EncodeString: (NSString *) strData {
	return [self base64EncodeData: [strData dataUsingEncoding: NSUTF8StringEncoding] ];
}

+ (NSString *) base64EncodeData: (NSData *) objData {
	const unsigned char * objRawData = [objData bytes];
	char * objPointer;
	char * strResult;
    
	// Get the Raw Data length and ensure we actually have data
	int intLength = [objData length];
	if (intLength == 0) return nil;
    
	// Setup the String-based Result placeholder and pointer within that placeholder
	strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
	objPointer = strResult;
    
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3;
	}
    
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
    
	// Terminate the string-based result
	*objPointer = '\0';
    
	// Return the results as an NSString object
	return [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
}

+ (NSData *) base64DecodeString: (NSString *) strBase64 {
	const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
	int intLength = strlen(objPointer);
	int intCurrent;
	int i = 0, j = 0, k;
    
	unsigned char * objResult;
	objResult = calloc(intLength, sizeof(char));
    
	// Run through the whole string, converting as we go
	while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
		if (intCurrent == '=') {
			if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
				// the padding character is invalid at this point -- so this entire string is invalid
				free(objResult);
				return nil;
			}
			continue;
		}
        
		intCurrent = _base64DecodingTable[intCurrent];
		if (intCurrent == -1) {
			// we're at a whitespace -- simply skip over
			continue;
		} else if (intCurrent == -2) {
			// we're at an invalid character
			free(objResult);
			return nil;
		}
        
		switch (i % 4) {
			case 0:
				objResult[j] = intCurrent << 2;
				break;
                
			case 1:
				objResult[j++] |= intCurrent >> 4;
				objResult[j] = (intCurrent & 0x0f) << 4;
				break;
                
			case 2:
				objResult[j++] |= intCurrent >>2;
				objResult[j] = (intCurrent & 0x03) << 6;
				break;
                
			case 3:
				objResult[j++] |= intCurrent;
				break;
		}
		i++;
	}
    
	// mop things up if we ended on a boundary
	k = j;
	if (intCurrent == '=') {
		switch (i % 4) {
			case 1:
				// Invalid state
				free(objResult);
				return nil;
                
			case 2:
				k++;
				// flow through
			case 3:
				objResult[k] = 0;
		}
	}
    
	// Cleanup and setup the return NSData
	NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
	free(objResult);
	return objData;
}

+ (void)showWarningWithText:(NSString *)warningText {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:BKLocalizedString(@"Warning title") message:warningText delegate:nil cancelButtonTitle:BKLocalizedString(@"OK btn") otherButtonTitles:nil];
    [alert show];
}

+ (void)showErrorWithText:(NSString *)warningText {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:BKLocalizedString(@"Error title") message:warningText delegate:nil cancelButtonTitle:BKLocalizedString(@"OK btn") otherButtonTitles:nil];
    [alert show];
}

+ (void)showResponseErrorForNetworkManager:(BKNetworkManager *)manager {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:BKLocalizedString(@"Error title") message:BKLocalizedString(@"Exchange server can't authorize the app. Please recheck your api keys or use demo keys") delegate:nil cancelButtonTitle:BKLocalizedString(@"OK btn") otherButtonTitles:nil];
    [alert show];
}

+ (void)fillView:(UIView *)v withPatternImageNamed:(NSString *)imgName {
    
    UIImage *img = [UIImage imageNamed:imgName];
    v.backgroundColor = [UIColor colorWithPatternImage:img];
}

+ (UITableView *)parentTableForView:(UIView *)view {
    
    UIView *aView = view;
    while(aView != nil) {
        
        if([aView isKindOfClass:[UITableView class]]) {
            
            return (UITableView *)aView;
        }
        aView = aView.superview;
    }
    return nil;
}

+ (UITableViewCell *)parentCellForView:(UIView *)view {
    
    UIView *aView = view;
    while(aView != nil) {
        
        if([aView isKindOfClass:[UITableViewCell class]]) {
            
            return (UITableViewCell *)aView;
        }
        aView = aView.superview;
    }
    return nil;
}

@end

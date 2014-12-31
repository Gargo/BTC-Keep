//
//  BKNetworkManagerProtocol.h
//  BTCKeep
//
//  Created by Apple on 18.05.14.
//  
//

#import <Foundation/Foundation.h>
#import "BKNetworkManager.h"

@protocol BKNetworkManagerProtocol <NSObject>

//Network success and failure methods
- (void)requestSuccessWithRequestType:(BKRequestType)requestType requestBlockType:(BKRequestBlockType)requestBlockType completionPercent:(int)completionPercent;
- (void)requestFailureWithRequestType:(BKRequestType)requestType requestBlockType:(BKRequestBlockType)requestBlockType completionPercent:(int)completionPercent;

@end

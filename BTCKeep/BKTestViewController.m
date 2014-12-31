//
//  BKTestViewController.m
//  BTCKeep
//
//  Created by Apple on 24.05.14.
//  
//

#import "BKTestViewController.h"

@interface BKTestViewController ()

@end

@implementation BKTestViewController

#pragma mark - Actions

/*- (IBAction)onGetCurrenciesBtn:(id)sender {
    
    NSURLSessionTask *task = [networkManager getCurrenciesWithRequestBlockId:BKRequestBlockNone block:^(int requestType, int requestBlockType, NSError *error, int completionPercent) {
        
        if (error) {
            
            [self requestFailureWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
        else {
            
            [self requestSuccessWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (IBAction)onGetTradePairsBtn:(id)sender {
    
    NSURLSessionTask *task = [networkManager getTradePairsWithRequestBlockId:BKRequestBlockNone block:^(int requestType, int requestBlockType, NSError *error, int completionPercent) {
        
        if (error) {
            
            [self requestFailureWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
        else {
            
            [self requestSuccessWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (IBAction)onGetOrdersBtn:(id)sender {
    
    NSURLSessionTask *task = [networkManager getOrdersForTradePairID:@1 requestBlockId:BKRequestBlockNone block:^(int requestType, int requestBlockType, NSError *error, int completionPercent) {
        
        if (error) {
            
            [self requestFailureWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
        else {
            
            [self requestSuccessWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (IBAction)onGetTradesBtn:(id)sender {
    
    NSURLSessionTask *task = [networkManager getTradesForTradePairID:@1 requestBlockId:BKRequestBlockNone block:^(int requestType, int requestBlockType, NSError *error, int completionPercent) {
        
        if (error) {
            
            [self requestFailureWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
        else {
            
            [self requestSuccessWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (IBAction)onGetOrderStatusBtn:(id)sender {
    
    NSURLSessionTask *task = [networkManager getOrderStatusForID:@1 requestBlockId:BKRequestBlockNone block:^(int requestType, int requestBlockType, NSError *error, int completionPercent) {
        
        if (error) {
            
            [self requestFailureWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
        else {
            
            [self requestSuccessWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (IBAction)onGetOpenedOrdersBtn:(id)sender {
    
    NSURLSessionTask *task = [networkManager getOpenedOrdersWithRequestBlockId:BKRequestBlockNone block:^(int requestType, int requestBlockType, NSError *error, int completionPercent) {
        
        if (error) {
            
            [self requestFailureWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
        else {
            
            [self requestSuccessWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (IBAction)onGetBalancesBtn:(id)sender {
    
    NSURLSessionTask *task = [networkManager getBalancesWithRequestBlockId:BKRequestBlockNone block:^(int requestType, int requestBlockType, NSError *error, int completionPercent) {
        
        if (error) {
            
            [self requestFailureWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
        else {
            
            [self requestSuccessWithRequestType:requestType requestBlockType:BKRequestBlockNone completionPercent:completionPercent];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}*/

@end

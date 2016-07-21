//
//  AQHybridService.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "AQWebViewController.h"

/**
 // registerPlugin
 [AQHybridRegister registerService:[AQHybridService new] hostname:@"accountBridge"];
 
 // hybrid://accountBridge:1001/auth?{xxx:xxx, xxx:xxx}
 - (id)auth:(NSDictionary *)params {
    // 处理URL对应的native方法：
 }
 */
@interface AQHybridService : NSObject
/** 控制器 */
@property (nonatomic, weak) AQWebViewController *vc;
/** 网页 */
@property (nonatomic, weak) UIWebView *webView;
/** 待处理 */
@property (assign, readonly) BOOL hasPendingOperation;

#pragma mark life cycle
- (instancetype)initWithVC:(UIViewController *)vc webView:(UIWebView *)webView;
- (void)pInitialize;
- (void)pDestory;

#pragma mark java script
- (void)evaluatingJavaScript:(NSString *)script;
- (NSString *)createJavaScript:(NSString *)callback requestId:(NSString *)requestId data:(NSString *)data;
@end

//
//  AQHybridContext.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "AQWebViewController.h"

/** 网页上下文 */
@interface AQHybridContext : NSObject
/** 控制器 */
@property (nonatomic, weak) AQWebViewController *viewController;
/** 网页 */
@property (nonatomic, weak) UIWebView *webView;
/** 创建 */
+ (instancetype)context:(UIViewController *)vc webView:(UIWebView *)webView;
@end

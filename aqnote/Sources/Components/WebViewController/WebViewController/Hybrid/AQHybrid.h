//
//  AQHybrid.h
//  AQDemo
//
//  Created by madding.lip on 7/22/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>

@interface AQHybrid : NSObject<UIWebViewDelegate>

// 开启日志功能
+ (void)enableLogging;

// 初始化hybrid
+ (instancetype)initWithVC:(UIViewController *)vc WebView:(UIWebView *)webView;
// 初始化hybrid
+ (instancetype)initWithVC:(UIViewController *)vc
                   WebView:(UIWebView *)webView
                  delegate:(id<UIWebViewDelegate>)delegate;

@end

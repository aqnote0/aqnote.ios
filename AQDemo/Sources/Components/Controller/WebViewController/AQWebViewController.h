//
//  AQWebViewController.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQViewController.h"
#import "AQH5Delegate.h"
#import "AQWebView.h"

@interface AQWebViewController : AQViewController<UIWebViewDelegate>

@property(nonatomic, strong) AQWebView *webView;
@property (nonatomic, copy) NSString *openUrl;
@property (nonatomic, weak) id<AQH5Delegate> delegate;
@property(nonatomic, copy)NSString* callBackUrl;
@property (nonatomic, copy) void (^webViewDidStartLoad)(UIWebView *webView);
@property (nonatomic, copy) void (^didFinishLoad)(UIWebView *webView);
@property (nonatomic, copy) void (^didFailLoadWithError)(UIWebView *webView, NSError *error);

- (NSString *)webViewTitle;
- (void)startLoad;
- (void)stopLoad;
- (void)onBack;
- (void)closeWebView;

@end

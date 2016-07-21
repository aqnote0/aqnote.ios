//
//  WebViewJavascriptBridge.h
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>

#define SCHEME_HYBRID @"hybrid"
#define MESSAGE_QUEUE @"__AQ_QUEUE_MESSAGE__"

typedef void (^AQJBResponseCallback)(id responseData);
typedef void (^AQJBHandler)(id data, AQJBResponseCallback responseCallback);

@interface AQHybrid : NSObject<UIWebViewDelegate>

+ (instancetype)bridgeForWebView:(UIWebView*)webView
                         handler:(AQJBHandler)handler;
+ (instancetype)bridgeForWebView:(UIWebView*)webView
                 delegate:(id<UIWebViewDelegate>)delegate
                         handler:(AQJBHandler)handler;
+ (instancetype)bridgeForWebView:(UIWebView*)webView
                delegate:(id<UIWebViewDelegate>)delegate
                         handler:(AQJBHandler)handler
                  bundle:(NSBundle*)bundle;
+ (void)enableLogging;

- (void)send:(id)message;
- (void)send:(id)message
    responseCallback:(AQJBResponseCallback)responseCallback;
- (void)registerHandler:(NSString*)handlerName handler:(AQJBHandler)handler;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName
               data:(id)data
   responseCallback:(AQJBResponseCallback)responseCallback;

@end

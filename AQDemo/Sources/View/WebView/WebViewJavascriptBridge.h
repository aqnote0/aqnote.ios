//
//  WebViewJavascriptBridge.h
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCustomProtocolScheme @"ydjbscheme"
#define kQueueHasMessage @"__YDJB_QUEUE_MESSAGE__"

#if defined __MAC_OS_X_VERSION_MAX_ALLOWED
#import <WebKit/WebKit.h>
#define AQJB_PLATFORM_OSX
#define AQJB_WEBVIEW_TYPE WebView
#define AQJB_WEBVIEW_DELEGATE_TYPE NSObject
#elif defined __IPHONE_OS_VERSION_MAX_ALLOWED
#import <UIKit/UIWebView.h>
#define AQJB_PLATFORM_IOS
#define AQJB_WEBVIEW_TYPE UIWebView
#define AQJB_WEBVIEW_DELEGATE_TYPE NSObject<UIWebViewDelegate>
#endif

typedef void (^AQJBResponseCallback)(id responseData);
typedef void (^AQJBHandler)(id data, AQJBResponseCallback responseCallback);

@interface WebViewJavascriptBridge : AQJB_WEBVIEW_DELEGATE_TYPE

+ (instancetype)bridgeForWebView: (AQJB_WEBVIEW_TYPE*)webView
                         handler: (AQJBHandler)handler;
+ (instancetype)bridgeForWebView: (AQJB_WEBVIEW_TYPE*)webView
                 webViewDelegate: (AQJB_WEBVIEW_DELEGATE_TYPE*)webViewDelegate
                         handler: (AQJBHandler)handler;
+ (instancetype)bridgeForWebView: (AQJB_WEBVIEW_TYPE*)webView
                 webViewDelegate: (AQJB_WEBVIEW_DELEGATE_TYPE*)webViewDelegate
                         handler: (AQJBHandler)handler
                  resourceBundle:(NSBundle*)bundle;
+ (void)enableLogging;

- (void)send:(id)message;
- (void)send:(id)message
    responseCallback: (AQJBResponseCallback)responseCallback;
- (void)registerHandler:(NSString*)handlerName handler: (AQJBHandler)handler;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName
               data:(id)data
   responseCallback: (AQJBResponseCallback)responseCallback;

@end

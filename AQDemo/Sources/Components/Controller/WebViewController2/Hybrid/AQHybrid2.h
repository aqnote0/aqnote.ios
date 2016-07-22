//
//  AQHybrid2.h
//  AQDemo
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>

#define SCHEME_HYBRID @"hybrid"
#define MESSAGE_QUEUE @"__AQ_QUEUE_MESSAGE__"

typedef void (^AQHybridCallback)(id responseData);
typedef void (^AQHybridHandler)(id data, AQHybridCallback responseCallback);

@interface AQHybrid2 : NSObject<UIWebViewDelegate>

// 开启日志功能
+ (void)enableLogging;

// 初始化hybrid
+ (instancetype)initWithWebView:(UIWebView*)webView
                        handler:(AQHybridHandler)handler;
// 初始化hybrid
+ (instancetype)initWithWebView:(UIWebView*)webView
                       delegate:(id<UIWebViewDelegate>)delegate
                        handler:(AQHybridHandler)handler;

// 向webview注册一个本地方法
- (void)registerHandler:(NSString*)handlerName handler:(AQHybridHandler)handler;

// 向json发送一条消息：无任何返回信息
- (void)callDefaultHandler:(id)message;
// 向json发送一条消息：js处理后返回信息可通过callback获取
- (void)callDefaultHandler:(id)message callback:(AQHybridCallback)callback;

// 调用js中注册的handler：无参数、无返回内容
- (void)callHandler:(NSString*)handlerName;
// 调用js中注册的handler：参数为data、无返回内容
- (void)callHandler:(NSString*)handlerName data:(id)data;
// 调用js中注册的handler：参数为data、返回内容为再callback中，一json格式返回
- (void)callHandler:(NSString*)handlerName
               data:(id)data
           callback:(AQHybridCallback)callback;

@end

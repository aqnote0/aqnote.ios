//
//  AQHybrid2.h
//  AQDemo
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import "AQHybrid2.h"

#import <AQFoundation/AQBundle.h>
#import <AQFoundation/AQSafeMutableArray.h>
#import <AQFoundation/AQSafeMutableDictionary.h>
#import <AQFoundation/AQThread.h>

typedef NSDictionary AQHybridMessage;

static bool logging = false;

@interface AQHybrid2 ()

@property(nonatomic, weak) UIWebView *webView;
@property(nonatomic, weak) id<UIWebViewDelegate> delegate;
@property(atomic, retain)
    AQSafeMutableArray<AQHybridMessage *> *startupMessageQueue;
@property(atomic, retain)
    AQSafeMutableDictionary<NSString *, AQHybridCallback> *callbacks;
@property(atomic, retain)
    AQSafeMutableDictionary<NSString *, AQHybridHandler> *handlers;
@property(atomic, assign) long uniqueId;

@property(atomic, assign) NSUInteger numRequestsLoading;
@property(nonatomic, copy) AQHybridHandler handler;

@end

@implementation AQHybrid2

+ (void)enableLogging {
  logging = true;
}

+ (instancetype)initWithWebView:(UIWebView *)webView
                        handler:(AQHybridHandler)handler {
  return [self initWithWebView:webView delegate:nil handler:handler];
}

+ (instancetype)initWithWebView:(UIWebView *)webView
                       delegate:(id<UIWebViewDelegate>)delegate
                        handler:(AQHybridHandler)handler {
  AQHybrid2 *hybrid = [[AQHybrid2 alloc] init];
  [hybrid _initWithWebView:webView delegate:delegate handler:handler];
  return hybrid;
}

- (id)init {
  if (self = [super init]) {
    _startupMessageQueue = [[AQSafeMutableArray alloc] init];
    _callbacks = [[AQSafeMutableDictionary alloc] init];
    _uniqueId = 0;
  }
  return self;
}

- (void)dealloc {
  _webView.delegate = nil;
  _webView = nil;
  _delegate = nil;
  _startupMessageQueue = nil;
  _callbacks = nil;
  _handlers = nil;
  _handler = nil;
}

- (void)_initWithWebView:(UIWebView *)webView
                delegate:(id<UIWebViewDelegate>)delegate
                 handler:(AQHybridHandler)handler {
  _handler = handler;
  _webView = webView;
  _delegate = delegate;
  _handlers = [[AQSafeMutableDictionary alloc] init];
  _webView.delegate = self;
}

- (void)registerHandler:(NSString *)handlerName
                handler:(AQHybridHandler)handler {
  [_handlers setObject:[handler copy] forKey:handlerName];
}

- (void)callDefaultHandler:(id)data {
  [self callDefaultHandler:data callback:nil];
}

- (void)callDefaultHandler:(id)data callback:(AQHybridCallback)callback {
  [self _callHandler:data callback:callback handlerName:nil];
}

- (void)callHandler:(NSString *)handlerName {
  [self callHandler:handlerName data:nil callback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
  [self callHandler:handlerName data:data callback:nil];
}

- (void)callHandler:(NSString *)handlerName
               data:(id)data
           callback:(AQHybridCallback)callback {
  [self _callHandler:data callback:callback handlerName:handlerName];
}

- (void)_callHandler:(id)data
            callback:(AQHybridCallback)callback
         handlerName:(NSString *)handlerName {
  NSMutableDictionary *message = [NSMutableDictionary dictionary];

  if (data) {
    message[@"data"] = data;
  }

  if (_callbacks) {
    NSString *callbackId =
        [NSString stringWithFormat:@"aqhybrid_%ld", ++_uniqueId];
    [_callbacks setObject:[callback copy] forKey:callbackId];
    message[@"callbackId"] = callbackId;
  }

  if (handlerName) {
    message[@"handlerName"] = handlerName;
  }
  [self _queueMessage:message];
}

- (void)_queueMessage:(AQHybridMessage *)message {
  if (_startupMessageQueue) {
    [_startupMessageQueue addObject:message];
  } else {
    [self _dispatchMessage:message];
  }
}

- (void)_dispatchMessage:(AQHybridMessage *)message {
  NSString *messageJSON = [self _serializeJSMessage:message];
  NSString *javascript =
      [NSString stringWithFormat:@"AQHybrid.handleMessage('%@');", messageJSON];
  __strong UIWebView *sWebView = _webView;
  if([NSThread isMainThread]) {  // 如果当前是主线程，必须要用weak的webivew调用js，否则可能导致死锁
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
  } else {
    [AQThread foreground:^{
      [sWebView stringByEvaluatingJavaScriptFromString:javascript];
    }];
  }
}

- (void)_flushMessageQueue {
  NSString *messageQueueString = [_webView
      stringByEvaluatingJavaScriptFromString:@"AQHybrid.fetchQueue();"];

  id messages = [self _deserializeMessage:messageQueueString];
  if (![messages isKindOfClass:[NSArray class]]) {
    NSLog(@"AQHybrid: WARNING: Invalid %@ received: %@", [messages class],
          messages);
    return;
  }
  for (AQHybridMessage *message in messages) {
    if (![message isKindOfClass:[AQHybridMessage class]]) {
      NSLog(@"AQHybrid: WARNING: Invalid %@ received: %@", [message class],
            message);
      continue;
    }
    [self _log:@"Received" json:message];

    NSString *responseId = message[@"responseId"];
    if (responseId) {  // js请求
      AQHybridCallback callback = [_callbacks objectForKey:responseId];
      callback(message[@"responseData"]);
      [_callbacks removeObjectForKey:responseId];
    } else {  // oc请求
      AQHybridCallback responseCallback = NULL;
      NSString *callbackId = message[@"callbackId"];
      if (callbackId) {
        responseCallback = ^(id responseData) {
          if (responseData == nil) {
            responseData = [NSNull null];
          }

          AQHybridMessage *msg = @{
            @"responseId" : callbackId,
            @"responseData" : responseData
          };
          [self _queueMessage:msg];
        };
      } else {
        responseCallback = ^(id ignoreResponseData) {
          // Do nothing
        };
      }

      AQHybridHandler handler;
      if (message[@"handlerName"]) {
        handler = [_handlers objectForKey:message[@"handlerName"]];
      } else {
        handler = _handler;
      }

      if (!handler) {
        [NSException raise:@"AQHybridNoHandlerException"
                    format:@"No handler for message from JS: %@", message];
      }

      handler(message[@"data"], responseCallback);
    }
  }
}

- (NSString *)_serializeMessage:(id)message {
  return [[NSString alloc]
      initWithData:[NSJSONSerialization dataWithJSONObject:message
                                                   options:0
                                                     error:nil]
          encoding:NSUTF8StringEncoding];
}

- (NSArray *)_deserializeMessage:(NSString *)messageJSON {
  return [NSJSONSerialization
      JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding]
                 options:NSJSONReadingAllowFragments
                   error:nil];
}

- (NSString *)_serializeJSMessage:(id)message {
  NSString *messageJSON = [self _serializeMessage:message];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\"
                                                       withString:@"\\\\"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\""
                                                       withString:@"\\\""];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'"
                                                       withString:@"\\\'"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n"
                                                       withString:@"\\n"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r"
                                                       withString:@"\\r"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f"
                                                       withString:@"\\f"];
  messageJSON = [messageJSON
      stringByReplacingOccurrencesOfString:@"\u2028"
                                withString:@"\\u2028"];  // LINE SEPARATOR
  messageJSON =
      [messageJSON stringByReplacingOccurrencesOfString:@"\u2029"
                                             withString:@"\\u2029"];  //
  return messageJSON;
}

- (void)_log:(NSString *)action json:(id)json {
  if (!logging) {
    return;
  }
  if (![json isKindOfClass:[NSString class]]) {
    json = [self _serializeMessage:json];
  }
  if ([json length] > 500) {
    NSLog(@"AQHybrid %@: %@ [...]", action, [json substringToIndex:500]);
  } else {
    NSLog(@"AQHybrid %@: %@", action, json);
  }
}

#pragma UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  if (webView != _webView) {
    return;
  }

  // webview加载完成再去加载核心js
  _numRequestsLoading--;
  if (_numRequestsLoading == 0 &&
      ![[webView
          stringByEvaluatingJavaScriptFromString:@"typeof AQHybrid == 'object'"]
          isEqualToString:@"true"]) {
    NSString *javascript = [AQBundle bundleFileContent:@"AQHybrid2.js"
                                              fileType:@"txt"
                                            bundleName:@"AQDemo"];
    ;
    [webView stringByEvaluatingJavaScriptFromString:javascript];
  }

  if (_startupMessageQueue) {
    for (int i = 0; i < [_startupMessageQueue count]; i++) {
      AQHybridMessage *queuedMessage = [_startupMessageQueue objectAtIndex:i];
      [self _dispatchMessage:queuedMessage];
    }
    _startupMessageQueue = nil;
  }

  __strong id<UIWebViewDelegate> sDelegate = _delegate;
  if (sDelegate &&
      [sDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
    [sDelegate webViewDidFinishLoad:webView];
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if (webView != _webView) {
    return;
  }

  _numRequestsLoading--;

  __strong id<UIWebViewDelegate> sDelegate = _delegate;
  if (sDelegate &&
      [sDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
    [sDelegate webView:webView didFailLoadWithError:error];
  }
}

// 页面重新加载的入口，js和oc的代码交互点
- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  if (webView != _webView) {
    return YES;
  }
  NSURL *url = [request URL];
  __strong id<UIWebViewDelegate> sDelegate = _delegate;
  if ([[url scheme] isEqualToString:SCHEME_HYBRID]) {
    if ([[url host] isEqualToString:MESSAGE_QUEUE]) {
      [self _flushMessageQueue];
    } else {
      NSLog(@"AQHybrid: WARNING: Received unknown "
            @"AQHybrid command %@://%@",
            SCHEME_HYBRID, [url path]);
    }
    return NO;
  } else if (sDelegate &&
             [sDelegate respondsToSelector:@selector(webView:
                                               shouldStartLoadWithRequest:
                                                           navigationType:)]) {
    return [sDelegate webView:webView
        shouldStartLoadWithRequest:request
                    navigationType:navigationType];
  } else {
    return YES;
  }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  if (webView != _webView) {
    return;
  }

  _numRequestsLoading++;

  __strong id<UIWebViewDelegate> sDelegate = _delegate;
  if (sDelegate &&
      [sDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
    [sDelegate webViewDidStartLoad:webView];
  }
}

@end

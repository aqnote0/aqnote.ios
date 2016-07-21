//
//  AQHybrid.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import "AQHybrid.h"


#import <AQFoundation/AQSafeMutableArray.h>
#import <AQFoundation/AQSafeMutableDictionary.h>

typedef NSDictionary AQHybridMessage;

@implementation AQHybrid {
  __weak UIWebView *_webView;
  __weak id<UIWebViewDelegate> _delegate;
  AQSafeMutableArray<AQHybridMessage *> *_startupMessageQueue;
  AQSafeMutableDictionary *_responseCallbacks;
  AQSafeMutableDictionary *_messageHandlers;
  long _uniqueId;
  NSUInteger _numRequestsLoading;
  AQJBHandler _messageHandler;
  NSBundle *_resourceBundle;
}

static bool logging = false;
+ (void)enableLogging {
  logging = true;
}

+ (instancetype)bridgeForWebView:(UIWebView *)webView
                         handler:(AQJBHandler)handler {
  return [self bridgeForWebView:webView delegate:nil handler:handler];
}

+ (instancetype)bridgeForWebView:(UIWebView *)webView
                        delegate:(id<UIWebViewDelegate>)delegate
                         handler:(AQJBHandler)messageHandler {
  return [self bridgeForWebView:webView
                       delegate:delegate
                        handler:messageHandler
                         bundle:nil];
}

+ (instancetype)bridgeForWebView:(UIWebView *)webView
                        delegate:(id<UIWebViewDelegate>)delegate
                         handler:(AQJBHandler)handler
                          bundle:(NSBundle *)bundle {
  AQHybrid *bridge = [[AQHybrid alloc] init];
  [bridge _platformSpecificSetup:webView
                        delegate:delegate
                         handler:handler
                          bundle:bundle];
  return bridge;
}

- (void)send:(id)data {
  [self send:data responseCallback:nil];
}

- (void)send:(id)data responseCallback:(AQJBResponseCallback)responseCallback {
  [self _sendData:data responseCallback:responseCallback handlerName:nil];
}

- (void)callHandler:(NSString *)handlerName {
  [self callHandler:handlerName data:nil responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
  [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName
               data:(id)data
   responseCallback:(AQJBResponseCallback)responseCallback {
  [self _sendData:data
      responseCallback:responseCallback
           handlerName:handlerName];
}

- (void)registerHandler:(NSString *)handlerName handler:(AQJBHandler)handler {
  [_messageHandlers setObject:[handler copy] forKey:handlerName];
}

/* Platform agnostic internals
 *****************************/

- (id)init {
  if (self = [super init]) {
    _startupMessageQueue = [[AQSafeMutableArray alloc] init];
    _responseCallbacks = [[AQSafeMutableDictionary alloc]  init];
    _uniqueId = 0;
  }
  return self;
}

- (void)dealloc {
  [self _platformSpecificDealloc];

  _webView = nil;
  _delegate = nil;
  _startupMessageQueue = nil;
  _responseCallbacks = nil;
  _messageHandlers = nil;
  _messageHandler = nil;
}

- (void)_sendData:(id)data
 responseCallback:(AQJBResponseCallback)responseCallback
      handlerName:(NSString *)handlerName {
  NSMutableDictionary *message = [NSMutableDictionary dictionary];

  if (data) {
    message[@"data"] = data;
  }

  if (responseCallback) {
    NSString *callbackId =
        [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
    [_responseCallbacks setObject:[responseCallback copy] forKey:callbackId];
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

  NSString *javascriptCommand = [NSString
      stringWithFormat:@"AQHybrid._handleMessageFromObjC('%@');", messageJSON];
  if ([[NSThread currentThread] isMainThread]) {
    [_webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
  } else {
    __strong UIWebView *strongWebView = _webView;
    dispatch_sync(dispatch_get_main_queue(), ^{
      [strongWebView stringByEvaluatingJavaScriptFromString:javascriptCommand];
    });
  }
}

- (void)_flushMessageQueue {
  NSString *messageQueueString = [_webView
      stringByEvaluatingJavaScriptFromString:@"AQHybrid._fetchQueue();"];

  id messages = [self _deserializeMessageJSON:messageQueueString];
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
    [self _log:@"RCVD" json:message];

    NSString *responseId = message[@"responseId"];
    if (responseId) {  // js请求
      AQJBResponseCallback responseCallback = [_responseCallbacks objectForKey:responseId];
      responseCallback(message[@"responseData"]);
      [_responseCallbacks removeObjectForKey:responseId];
    } else {  // oc请求
      AQJBResponseCallback responseCallback = NULL;
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

      AQJBHandler handler;
      if (message[@"handlerName"]) {
        handler = [_messageHandlers objectForKey:message[@"handlerName"]];
      } else {
        handler = _messageHandler;
      }

      if (!handler) {
        [NSException raise:@"YDJBNoHandlerException"
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

- (NSArray *)_deserializeMessageJSON:(NSString *)messageJSON {
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
    NSLog(@"YDJB %@: %@ [...]", action, [json substringToIndex:500]);
  } else {
    NSLog(@"YDJB %@: %@", action, json);
  }
}

- (void)_platformSpecificSetup:(UIWebView *)webView
                      delegate:(id<UIWebViewDelegate>)delegate
                       handler:(AQJBHandler)messageHandler
                        bundle:(NSBundle *)bundle {
  _messageHandler = messageHandler;
  _webView = webView;
  _delegate = delegate;
  _messageHandlers = [[AQSafeMutableDictionary alloc] init];
  _webView.delegate = self;
  _resourceBundle = bundle;
}

- (void)_platformSpecificDealloc {
  _webView.delegate = nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  if (webView != _webView) {
    return;
  }

  _numRequestsLoading--;

  if (_numRequestsLoading == 0 &&
      ![[webView
          stringByEvaluatingJavaScriptFromString:@"typeof AQHybrid == 'object'"]
          isEqualToString:@"true"]) {
    NSBundle *bundle =
        _resourceBundle ? _resourceBundle : [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"AQHybrid.js" ofType:@"txt"];
    NSString *js = [NSString stringWithContentsOfFile:filePath
                                             encoding:NSUTF8StringEncoding
                                                error:nil];
    [webView stringByEvaluatingJavaScriptFromString:js];
  }

  if (_startupMessageQueue) {
    for(int i=0; i< [_startupMessageQueue count]; i++) {
      AQHybridMessage *queuedMessage = [_startupMessageQueue objectAtIndex:i];
      [self _dispatchMessage:queuedMessage];
    }
    _startupMessageQueue = nil;
  }

  __strong id<UIWebViewDelegate> strongDelegate = _delegate;
  if (strongDelegate &&
      [strongDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
    [strongDelegate webViewDidFinishLoad:webView];
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if (webView != _webView) {
    return;
  }

  _numRequestsLoading--;

  __strong id<UIWebViewDelegate> strongDelegate = _delegate;
  if (strongDelegate &&
      [strongDelegate
          respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
    [strongDelegate webView:webView didFailLoadWithError:error];
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
  __strong id<UIWebViewDelegate> strongDelegate = _delegate;
  if ([[url scheme] isEqualToString:SCHEME_HYBRID]) {
    if ([[url host] isEqualToString:MESSAGE_QUEUE]) {
      [self _flushMessageQueue];
    } else {
      NSLog(@"AQHybrid: WARNING: Received unknown "
            @"AQHybrid command %@://%@",
            SCHEME_HYBRID, [url path]);
    }
    return NO;
  } else if (strongDelegate &&
             [strongDelegate
                 respondsToSelector:@selector(webView:
                                        shouldStartLoadWithRequest:
                                                    navigationType:)]) {
    return [strongDelegate webView:webView
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

  __strong id<UIWebViewDelegate> strongDelegate = _delegate;
  if (strongDelegate &&
      [strongDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
    [strongDelegate webViewDidStartLoad:webView];
  }
}

@end

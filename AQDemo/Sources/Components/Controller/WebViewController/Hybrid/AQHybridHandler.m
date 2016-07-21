//
//  AQHybridHandler.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQHybridHandler.h"

#import <objc/message.h>

#import <AQFoundation/AQJSON.h>
#import <AQFoundation/AQLogger.h>
#import <AQFoundation/AQThread.h>
#import <AQFoundation/AQURL.h>

#import "AQHyBridResult.h"
#import "AQHybridRegister.h"

#ifndef AQ_SYSTEM_DOMAIN
#define AQ_SYSTEM_DOMAIN @"com.aqnote.demo.system"
#endif

#ifndef AQ_SYSTEM_NSERROR
#define AQ_SYSTEM_NSERROR(_code)                   \
  [[NSError alloc] initWithDomain:AQ_SYSTEM_DOMAIN \
                             code:_code              \
                         userInfo:[NSDictionary dictionary]]
#endif

extern NSString *createScript(NSString *callback, NSString *requestId,
                              NSString *data) {
  return [NSString stringWithFormat:@"%@('%@', %@)", callback, requestId, data];
}

@interface AQHybridThread : NSObject {
  dispatch_queue_t _backHybridQueue;
}
@end

@implementation AQHybridParam

- (instancetype)initWithURL:(NSURL *)url {
  self = [super init];
  if (self) {
    self.className = url.host;
    self.requestId = url.port.stringValue;

    //  设置方法名
    NSString *path = [url path];
    path = [path hasPrefix:@"/"] && 1 < path.length
               ? [path substringFromIndex:1]
               : path;

    NSArray *methods = [path componentsSeparatedByString:@"/"];
    if (methods && 0 < [methods count]) {
      // 传递的方法名
      NSString *method = [methods objectAtIndex:0];
      self.methodName = method;
    }

    // 设置参数
    NSString *paramJson = nil;
    NSString *urlString = [url absoluteString];
    NSRange r = [urlString rangeOfString:@"?"];
    if (r.length > 0) {
      NSString *query = [urlString
          substringFromIndex:[urlString rangeOfString:@"?"].location + 1];
      paramJson = ((query == nil) && (query.length == 0))
                      ? query
                      : [AQURL urlDecoded:query];
      self.param = [AQJSON jsonStringToDictionary:paramJson];
    }
  }
  return self;
}

- (BOOL)isDataRight {
  return self.className != nil && self.methodName != nil;
}
@end

#pragma mark -
#define CALLBACK_FAILURE @"window.AQBridge.onFailure"
#define CALLBACK_SUCCESS @"window.AQBridge.onSuccess"

@implementation AQHybridThread

+ (AQHybridThread *)sharedInstance {
  static AQHybridThread *sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[AQHybridThread alloc] init];
  });

  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _backHybridQueue = dispatch_queue_create(
        "com.alibaba.baichuan.queue.hybrid", DISPATCH_QUEUE_CONCURRENT);
  }
  return self;
}
+ (void)backgroundHybrid:(dispatch_block_t)block {
  return [[AQHybridThread sharedInstance] backgroundHybrid:block];
}
- (void)backgroundHybrid:(dispatch_block_t)block {
  dispatch_async(_backHybridQueue, block);
}

@end

@implementation AQHybridHandler

+ (AQHybridHandler *)sharedInstance {
  static AQHybridHandler *sharedHybridHandler;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedHybridHandler = [[AQHybridHandler alloc] init];
  });

  return sharedHybridHandler;
}

#pragma mark interface
+ (BOOL)isMatch:(NSURLRequest *)request {
  return [[AQHybridHandler sharedInstance] isMatch:request];
}

- (BOOL)isMatch:(NSURLRequest *)request {
  AQ_DEBUG(@"[URL_H]%@", [[request URL] absoluteString])
  NSString *schema = [[request URL] scheme];
  return [@"hybrid" isEqualToString:schema];
}

+ (void)handle:(NSURLRequest *)request context:(AQHybridContext *)context {
  return [[AQHybridHandler sharedInstance] handle:request context:context];
}

- (void)handle:(NSURLRequest *)request context:(AQHybridContext *)context {
  NSURL *url = [request URL];
  AQHybridParam *model = [[AQHybridParam alloc] initWithURL:url];

  // condition 2:参数错误
  if (![model isDataRight]) {
    NSString *returnData = [[AQHyBridResult build:NOT_FOUND] json];
    NSString *script =
        createScript(CALLBACK_SUCCESS, model.requestId, returnData);
    [AQThread foreground:^{
      [context.webView stringByEvaluatingJavaScriptFromString:script];
    }];
    return;
  }

  NSString *className =
      [[AQHybridRegister hostNames] objectForKey:model.className];
  if (!className) {
    NSString *returnData = [[AQHyBridResult build:NOT_FOUND] json];
    NSString *script =
        createScript(CALLBACK_SUCCESS, model.requestId, returnData);
    [AQThread foreground:^{
      [context.webView stringByEvaluatingJavaScriptFromString:script];
    }];
    return;
  }

  // 本地异步调用
  dispatch_block_t block = ^(void) {
    // condition 3:判断class类是否存在；不存在，结束
    AQHybridService *hybridService =
        [[AQHybridRegister services] objectForKey:className];
    if (!hybridService) {
      hybridService = [[NSClassFromString(className) alloc]
          initWithVC:context.viewController
             webView:context.webView];
      if (!hybridService) {
        AQ_DEBUG(@"[WebView]%@ can't find class", className);
        return;
      }
      [AQHybridRegister registerService:hybridService hostname:model.className];
    } else {
      hybridService.webView = context.webView;
      hybridService.vc = context.viewController;
    }

    NSString *sel = [NSString stringWithFormat:@"%@:", model.methodName];
    if (!hybridService ||
        ![hybridService respondsToSelector:NSSelectorFromString(sel)]) {
      AQ_DEBUG(@"target service not found:%@-%@", model.className,
               model.methodName);
      NSString *returnData = [[AQHyBridResult build:NOT_FOUND] json];
      NSString *script =
          createScript(CALLBACK_FAILURE, model.requestId, returnData);
      [AQThread foreground:^{
        [context.webView stringByEvaluatingJavaScriptFromString:script];
      }];
      return;
    }

    // 执行代码
    ((void (*)(id, SEL, AQHybridParam *))objc_msgSend)(
        hybridService, NSSelectorFromString(sel), model);
  };

  [AQHybridThread backgroundHybrid:block];
  return;
}
@end

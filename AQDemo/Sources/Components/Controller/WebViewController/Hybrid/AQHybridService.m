//
//  AQHybridService.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQHybridService.h"

#import <AQFoundation/AQThread.h>

#import "AQWebViewController.h"

@implementation AQHybridService

- (instancetype)initWithVC:(AQWebViewController *)vc webView:(UIWebView *)webView {
  self = [super init];
  if (self) {
    self.vc = vc;
    self.webView = webView;
  }
  return self;
}

- (void)evaluatingJavaScript:(NSString *)script {
    [AQThread foreground:^{
      [self.webView stringByEvaluatingJavaScriptFromString:script];
    }];
}

- (NSString *)createJavaScript:(NSString *)callback requestId:(NSString *)requestId data:(NSString *)data {
  return [NSString stringWithFormat:@"%@('%@', %@)", callback, requestId, data];
}

- (void)pInitialize {
  
}

- (void)pDestory {
  
}
@end

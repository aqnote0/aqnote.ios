//
//  AQWebView.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import "AQWebView.h"

@interface AQWebView ()

@property(nonatomic, copy) NSArray *scriptPrefixWhiteList;

@end

@implementation AQWebView
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.scriptPrefixWhiteList = @[
                                   @"typeof",
                                   @"document.cookie",
                                   @"document.title",
                                   @"navigator.userAgent",
                                   @"window.AQHybrid.onFailure",
                                   @"window.AQHybrid.onSuccess",
                                   @"window.AQHybrid"];
  }
  return self;
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script {
  for (NSString *prefix in _scriptPrefixWhiteList) {
    if ([script hasPrefix:prefix]) {
      return [super stringByEvaluatingJavaScriptFromString:script];
    }
  }
  NSAssert(NO, @"script:%@ no in white list", script);
  return nil;
}

@end

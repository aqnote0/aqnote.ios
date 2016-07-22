//
//  AQHybrid.m
//  AQDemo
//
//  Created by madding.lip on 7/22/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import "AQHybrid.h"

#import <AQFoundation/AQBundle.h>
#import <AQFoundation/MBProgressHUD.h>

#import "AQHybridHandler.h"

#define SCHEME_HYBRID @"hybrid"

static bool logging = false;

@interface AQHybrid ()

@property(nonatomic, weak) UIViewController *vc;
@property(nonatomic, weak) UIWebView *webView;
@property(nonatomic, weak) id<UIWebViewDelegate> delegate;

@property(atomic, assign) NSUInteger numRequestsLoading;

@end

@implementation AQHybrid

+ (void)enableLogging {
  logging = true;
}

+ (instancetype)initWithVC:(UIViewController *)vc WebView:(UIWebView *)webView {
  return [self initWithVC:(UIViewController *)vc WebView:webView delegate:nil];
}

+ (instancetype)initWithVC:(UIViewController *)vc
                   WebView:(UIWebView *)webView
                  delegate:(id<UIWebViewDelegate>)delegate {
  AQHybrid *hybrid = [[AQHybrid alloc] init];
  [hybrid _initWithVC:(UIViewController *)vc WebView:webView delegate:delegate];
  return hybrid;
}

- (void)_initWithVC:(UIViewController *)vc
            WebView:(UIWebView *)webView
           delegate:(id<UIWebViewDelegate>)delegate {
  _vc = vc;
  _webView = webView;
  _delegate = delegate;
  _webView.delegate = self;
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
    NSString *javascript = [AQBundle bundleFileContent:@"AQHybrid.js"
                                              fileType:@"txt"
                                            bundleName:@"AQDemo"];
    ;
    [webView stringByEvaluatingJavaScriptFromString:javascript];
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

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  if (webView != _webView) {
    return YES;
  }
  NSURL *url = [request URL];
  __strong id<UIWebViewDelegate> sDelegate = _delegate;
  if ([[url scheme] isEqualToString:SCHEME_HYBRID]) {
    [AQHybridHandler
         handle:[[NSURLRequest alloc] initWithURL:request.URL]
        context:[AQHybridContext context:self.vc webView:self.webView]];
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

@end

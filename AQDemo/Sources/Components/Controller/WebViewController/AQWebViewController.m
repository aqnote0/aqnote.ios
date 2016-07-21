//
//  AQWebViewController.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQWebViewController.h"

#import <AQFoundation/AQLogger.h>
#import <AQFoundation/AQThread.h>
#import <AQFoundation/MBProgressHUD.h>
#import <AQFoundation/Reachability.h>

#import "AQHybridRegister.h"
#import "AQUtils.h"
#import "AQHybridContext.h"
#import "AQHybridHandler.h"


#define AQWebViewControllerURL @"AQWebViewControllerURL"

@interface AQWebViewController ()

@property(nonatomic) BOOL isConnected;
@property(atomic, strong) Reachability *reachability;

@end

@implementation AQWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self monitorNetwork];

  self.webView = [[AQWebView alloc] initWithFrame:self.view.bounds];
  self.webView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.webView.backgroundColor = UIColorFromRGB(0xeeeeee);
  self.webView.delegate = self;
  [self.view addSubview:self.webView];
  self.webView.scalesPageToFit = YES;

  if (self.push) {
  } else {
    if ([AQUtils iOS7OrLater]) {
      self.navigationController.navigationBar.barTintColor =
          UIColorFromRGB(0xf8f8f8);
    } else {
      self.navigationController.navigationBar.tintColor =
          UIColorFromRGB(0xf8f8f8);
    }
  }

  if (![self isConnected]) {
    [AQThread foreground:^{
      [AQUtils toast:@"connecting failed."];
    }];
  } else {
    [self startLoad];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [self stopLoad];
  self.delegate = nil;
  [super viewDidDisappear:animated];
}

#pragma mark interface
- (NSString *)webViewTitle {
  return
      [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)startLoad {
  [MBProgressHUD showHUDAddedTo:self.webView animated:NO];

  [AQThread foreground:^{
    if (_openUrl != nil) {
      NSMutableURLRequest *request = [NSMutableURLRequest
          requestWithURL:[NSURL URLWithString:self.openUrl]];
      [self.webView loadRequest:request];
    }
  }];
}

- (void)stopLoad {
  [self.webView stopLoading];
}

- (void)onBack {
  [super onBack];
}

- (void)closeWebView {
  [super onBack];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  if (self.webViewDidStartLoad) self.webViewDidStartLoad(webView);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [MBProgressHUD hideAllHUDsForView:_webView animated:NO];
  NSString *title =
      [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
  self.navigationItem.title = title;
  self.title = title;
  if (self.didFinishLoad) self.didFinishLoad(webView);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [MBProgressHUD hideAllHUDsForView:_webView animated:NO];

  NSString *failingURL =
      [[error userInfo] objectForKey:@"NSErrorFailingURLStringKey"];
  AQ_DEBUG(@"%@ load failed: %@", failingURL, error);

  if (self.didFailLoadWithError) self.didFailLoadWithError(webView, error);
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  NSString *urlStr = [request.URL absoluteString];
  if (![self.openUrl isEqualToString:urlStr] &&
      [self isCallbackUrl:request.URL.absoluteString]) {
    NSDictionary *urlParams = [AQUtils queryParamsOfUrl:request.URL];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if (urlParams.count > 0) {
      [paramsDict addEntriesFromDictionary:urlParams];
    }

    if (urlStr.length > 0) {
      [paramsDict setObject:urlStr forKey:AQWebViewControllerURL];
    }
    [MBProgressHUD hideAllHUDsForView:self.webView animated:NO];

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([weakSelf.delegate
              respondsToSelector:@selector(viewControllerCallback:params:)]) {
        [weakSelf.delegate viewControllerCallback:weakSelf params:paramsDict];
      }
    });

    [self stopLoad];
    [super onBack];
    return NO;
  }
  [AQHybridHandler handle:[[NSURLRequest alloc] initWithURL:request.URL]
                  context:[AQHybridContext context:self webView:self.webView]];
  return YES;
}

- (BOOL)isCallbackUrl:(NSString *)url {
  return ((self.callBackUrl.length > 0 && [url hasPrefix:self.callBackUrl]));
}

- (void)monitorNetwork {
  __weak __block typeof(self) weakself = self;
  self.reachability = [Reachability reachabilityForInternetConnection];

  self.reachability.reachableBlock = ^(Reachability *reachability) {
    weakself.isConnected = YES;
    NSString *temp =
        [NSString stringWithFormat:@"Connection Reachable(%@)",
                                   reachability.currentReachabilityFlags];
    NSLog(@"%@", temp);

  };

  self.reachability.unreachableBlock = ^(Reachability *reachability) {
    weakself.isConnected = NO;
    NSString *temp =
        [NSString stringWithFormat:@"Connection Unreachable(%@)",
                                   reachability.currentReachabilityFlags];
    NSLog(@"%@", temp);

  };

  [self.reachability startNotifier];
}

@end

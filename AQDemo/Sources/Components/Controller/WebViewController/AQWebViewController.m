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
#import <AQFoundation/Reachability.h>

#import "AQHybridContext.h"
#import "AQHybridRegister.h"
#import "AQUtils.h"

@interface AQWebViewController ()

@property(nonatomic) BOOL isConnected;
@property(atomic, strong) Reachability *reachability;

@end

@implementation AQWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self monitorNetwork];

  self.webView = [[AQWebView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.webView];

  [AQHybrid enableLogging];

  self.hybrid = [AQHybrid initWithVC:self WebView:self.webView delegate:self];

  if (![self isConnected]) {
    [AQThread foreground:^{
      [AQUtils toast:@"connecting failed."];
    }];
  }
}

- (void)monitorNetwork {
  __weak __block typeof(self) weakself = self;
  self.reachability = [Reachability reachabilityForInternetConnection];

  self.reachability.reachableBlock = ^(Reachability *reachability) {
    weakself.isConnected = YES;
    AQ_DEBUG(@"Connection Reachable(%@)",
             reachability.currentReachabilityFlags);
  };

  self.reachability.unreachableBlock = ^(Reachability *reachability) {
    weakself.isConnected = NO;
    AQ_DEBUG(@"Connection Unreachable(%@)",
             reachability.currentReachabilityFlags);
  };

  [self.reachability startNotifier];
}

@end

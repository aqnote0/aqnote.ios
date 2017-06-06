//
//  ExampleAppViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "AQWebViewController2.h"
#import "MBProgressHUD.h"

@implementation AQWebViewController2

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"hybrid";

  if (self.hybrid) {
    return;
  }

  self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.webView];

  [AQHybrid2 enableLogging];

  self.hybrid =
      [AQHybrid2 initWithWebView:self.webView
                       delegate:self
                        handler:^(id data, AQHybridCallback callback) {
                          NSLog(@"%@ received: %@", NSStringFromSelector(_cmd), data);
                          callback(data);
                        }];
}

@end

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

  if (self.bridge) {
    return;
  }

  self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.webView];

  [AQHybrid enableLogging];

  self.bridge = [AQHybrid
      bridgeForWebView:self.webView
              delegate:self
               handler:^(id data, AQJBResponseCallback responseCallback) {
                 NSLog(@"received from JS: %@", data);
                 responseCallback(data);
               }];
}

- (NSString*)_serializeMessage:(id)message {
  return [[NSString alloc]
      initWithData:[NSJSONSerialization dataWithJSONObject:message
                                                   options:0
                                                     error:nil]
          encoding:NSUTF8StringEncoding];
}

@end

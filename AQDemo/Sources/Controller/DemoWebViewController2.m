//
//  ExampleAppViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "AQHybrid2.h"
#import "AQWebViewController2.h"
#import "MBProgressHUD.h"

#import <AQFoundation/AQBundle.h>

@interface DemoWebViewController2 : AQWebViewController2

@end

@implementation DemoWebViewController2

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"hybrid";

  [self.hybrid registerHandler:@"hudHandler"
                       handler:^(id data, AQHybridCallback callback) {
                         NSLog(@"callHUD called: %@", data);
                         [MBProgressHUD
                             showTextOnly:self.view
                                  message:[self _serializeMessage:data]];
                         callback(data);
                       }];

  [self renderButtons];
  [self loadPage];
}

- (void)renderButtons {
  UIButton* messageButton = [[UIButton alloc] init];
  [messageButton setFrame:CGRectMake(10, 400, 200, 35)];
  [messageButton setBackgroundColor:[UIColor blackColor]];
  [messageButton setTitle:@"Native->H5 Default" forState:UIControlStateNormal];
  [messageButton addTarget:self
                    action:@selector(callDefault:)
          forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:messageButton aboveSubview:self.webView];

  UIButton* callbackButton = [[UIButton alloc] init];
  [callbackButton setFrame:CGRectMake(10, 450, 200, 35)];
  [callbackButton setBackgroundColor:[UIColor blackColor]];
  [callbackButton setTitle:@"Native->H5 Alert" forState:UIControlStateNormal];
  [callbackButton addTarget:self
                     action:@selector(callAlert:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:callbackButton aboveSubview:self.webView];

  UIButton* reloadButton = [[UIButton alloc] init];
  [reloadButton setFrame:CGRectMake(10, 500, 200, 35)];
  [reloadButton setBackgroundColor:[UIColor blackColor]];
  [reloadButton setTitle:@"Native->H5 Clean" forState:UIControlStateNormal];
  [reloadButton addTarget:self.webView
                   action:@selector(reload)
         forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:reloadButton aboveSubview:self.webView];
}

- (void)callDefault:(id)sender {
  [self.hybrid callDefaultHandler:@"OC Data"
                         callback:^(id response) {
                           NSLog(@"%@ callback: %@", NSStringFromSelector(_cmd), response);
                         }];
}

- (void)callAlert:(id)sender {
  [self.hybrid callHandler:@"alertHandler"
                      data:@"OC Data"
                  callback:^(id response) {
                    NSLog(@"%@ callback: %@", NSStringFromSelector(_cmd), response);
                  }];
}

- (void)loadPage {
  NSString* htmlPath =
      [[NSBundle mainBundle] pathForResource:@"webview" ofType:@"html"];
  NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
  NSURL* baseURL = [NSURL fileURLWithPath:htmlPath];
  [self.webView loadHTMLString:appHtml baseURL:baseURL];
}

- (NSString*)_serializeMessage:(id)message {
  return [[NSString alloc]
      initWithData:[NSJSONSerialization dataWithJSONObject:message
                                                   options:0
                                                     error:nil]
          encoding:NSUTF8StringEncoding];
}

@end

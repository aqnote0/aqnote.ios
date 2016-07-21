//
//  ExampleAppViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "AQWebViewController2.h"
#import "MBProgressHUD.h"
#import "AQHybrid.h"

#import <AQFoundation/AQBundle.h>

@interface DemoWebViewController2 : AQWebViewController2

@end

@implementation DemoWebViewController2

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"hybrid";
  
  [self.bridge registerHandler:@"hudHandler"
                   handler:^(id data, AQJBResponseCallback responseCallback) {
                     NSLog(@"callHUD called: %@", data);
                     [MBProgressHUD showTextOnly:self.view
                                         message:[self _serializeMessage:data]];
                     responseCallback(data);
                   }];
  
  [self renderButtons];
  [self loadPage];
}

- (void)renderButtons {

  UIButton* messageButton = [[UIButton  alloc] init];
  [messageButton setFrame:CGRectMake(10, 414, 100, 35)];
  [messageButton setBackgroundColor:[UIColor blackColor]];
  [messageButton setTitle:@"Call Send" forState:UIControlStateNormal];
  [messageButton addTarget:self
                    action:@selector(sendMessage:)
          forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:messageButton aboveSubview:self.webView];
  

  UIButton* callbackButton = [[UIButton  alloc] init];
  [callbackButton setFrame:CGRectMake(110, 414, 100, 35)];
  [callbackButton setBackgroundColor:[UIColor blackColor]];
  [callbackButton setTitle:@"call Alert" forState:UIControlStateNormal];
  [callbackButton addTarget:self
                     action:@selector(callAlert:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:callbackButton aboveSubview:self.webView];

  UIButton* reloadButton = [[UIButton  alloc] init];
  [reloadButton setFrame:CGRectMake(210, 414, 100, 35)];
  [reloadButton setBackgroundColor:[UIColor blackColor]];
  [reloadButton setTitle:@"Call Clean" forState:UIControlStateNormal];
  [reloadButton addTarget:self.webView
                   action:@selector(reload)
         forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:reloadButton aboveSubview:self.webView];
}

- (void)sendMessage:(id)sender {
  [self.bridge send:@"OC Data"
      responseCallback:^(id response) {
        NSLog(@"sendMessage got response: %@", response);
      }];
}

- (void)callAlert:(id)sender {
  [self.bridge callHandler:@"alertHandler"
                  data:@"OC Data"
      responseCallback:^(id response) {
        NSLog(@"alertHandler responded: %@", response);
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

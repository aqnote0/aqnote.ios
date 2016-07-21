//
//  ExampleAppViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "AQViewController.h"
#import "MBProgressHUD.h"
#import "WebViewJavascriptBridge.h"

@interface WebViewController : AQViewController<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;

@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"viewWillAppear");
  if (_bridge) {
    return;
  }

  UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:webView];

  [WebViewJavascriptBridge enableLogging];

  _bridge = [WebViewJavascriptBridge
      bridgeForWebView:webView
       webViewDelegate:self
               handler:^(id data, AQJBResponseCallback responseCallback) {
                 NSLog(@"received from JS: %@", data);
                 responseCallback(data);
               }];

  [_bridge registerHandler:@"hudHandler"
                   handler:^(id data, AQJBResponseCallback responseCallback) {
                     NSLog(@"callHUD called: %@", data);
                     [MBProgressHUD showTextOnly:self.view
                                         message:[self _serializeMessage:data]];
                     responseCallback(data);
                   }];

  [self renderButtons:webView];
  [self loadPage:webView];
}

- (void)webViewDidStartLoad:(UIWebView*)webView {
  NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
  NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(UIWebView*)webView {
  UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];

  UIButton* messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [messageButton setTitle:@"Call CM JS" forState:UIControlStateNormal];
  [messageButton addTarget:self
                    action:@selector(sendMessage:)
          forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:messageButton aboveSubview:webView];
  messageButton.frame = CGRectMake(10, 414, 100, 35);
  messageButton.titleLabel.font = font;
  messageButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];

  UIButton* callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [callbackButton setTitle:@"Call alertHandler" forState:UIControlStateNormal];
  [callbackButton addTarget:self
                     action:@selector(callHandler:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:callbackButton aboveSubview:webView];
  callbackButton.frame = CGRectMake(110, 414, 100, 35);
  callbackButton.titleLabel.font = font;

  UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
  [reloadButton addTarget:webView
                   action:@selector(reload)
         forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:reloadButton aboveSubview:webView];
  reloadButton.frame = CGRectMake(210, 414, 100, 35);
  reloadButton.titleLabel.font = font;
}

- (void)sendMessage:(id)sender {
  [_bridge send:@"OC Data"
      responseCallback:^(id response) {
        NSLog(@"sendMessage got response: %@", response);
      }];
}

- (void)callHandler:(id)sender {
  id data = @{ @"greetingFromObjC" : @"Hi there, JS!" };
  [_bridge callHandler:@"alertHandler"
                  data:data
      responseCallback:^(id response) {
        NSLog(@"alertHandler responded: %@", response);
      }];
}

- (void)loadPage:(UIWebView*)webView {
  NSString* htmlPath =
      [[NSBundle mainBundle] pathForResource:@"webview" ofType:@"html"];
  NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
  NSURL* baseURL = [NSURL fileURLWithPath:htmlPath];
  [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (NSString*)_serializeMessage:(id)message {
  return [[NSString alloc]
      initWithData:[NSJSONSerialization dataWithJSONObject:message
                                                   options:0
                                                     error:nil]
          encoding:NSUTF8StringEncoding];
}

@end

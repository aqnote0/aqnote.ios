//
//  ExampleAppViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "AQWebViewController.h"

#import <AQFoundation/AQBundle.h>

@interface WebViewController : AQWebViewController

@end

@implementation WebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"hybrid";
  
  [self renderButtons];
  [self loadPage];
}

- (void)renderButtons {
  UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];

  UIButton* messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [messageButton setTitle:@"Call CM JS" forState:UIControlStateNormal];
  [messageButton addTarget:self
                    action:@selector(sendMessage:)
          forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:messageButton aboveSubview:self.webView];
  messageButton.frame = CGRectMake(10, 414, 100, 35);
  messageButton.titleLabel.font = font;
  messageButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];

  UIButton* callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [callbackButton setTitle:@"Call alertHandler" forState:UIControlStateNormal];
  [callbackButton addTarget:self
                     action:@selector(callHandler:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:callbackButton aboveSubview:self.webView];
  callbackButton.frame = CGRectMake(110, 414, 100, 35);
  callbackButton.titleLabel.font = font;

  UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
  [reloadButton addTarget:self.webView
                   action:@selector(reload)
         forControlEvents:UIControlEventTouchUpInside];
  [self.view insertSubview:reloadButton aboveSubview:self.webView];
  reloadButton.frame = CGRectMake(210, 414, 100, 35);
  reloadButton.titleLabel.font = font;
}

- (void)sendMessage:(id)sender {
  
}

- (void)callHandler:(id)sender {
  
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

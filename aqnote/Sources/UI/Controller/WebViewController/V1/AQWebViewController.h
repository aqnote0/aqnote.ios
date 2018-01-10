//
//  AQWebViewController.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQViewController.h"
#import "AQWebView.h"
#import "AQHybrid.h"

@interface AQWebViewController : AQViewController<UIWebViewDelegate>

@property(nonatomic, retain) AQHybrid* hybrid;
@property(nonatomic, strong) AQWebView *webView;

@end

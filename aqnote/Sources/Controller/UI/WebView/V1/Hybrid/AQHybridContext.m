//
//  AQHybridContext.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQHybridContext.h"

@implementation AQHybridContext

+ (instancetype)context:(AQWebViewController *)vc webView:(UIWebView *)webView {
    AQHybridContext *context = [[AQHybridContext alloc] init];
    context.viewController = vc;
    context.webView = webView;
    return context;
}
@end

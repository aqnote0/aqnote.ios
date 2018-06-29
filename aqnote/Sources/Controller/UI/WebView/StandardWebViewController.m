//
//  ExampleAppViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "AQWebViewController.h"

#import <AQFoundation/AQBundle.h>
#import <AQFoundation/AQDate.h>

#define COOKIE_AQNOTE_COM @".aqnote.com"
#define COOKIE_SID @"sid"


@interface DemoWebViewController : AQViewController<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation DemoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView setDelegate:self];
    
    [self.view addSubview:self.webView];
    [self renderButtons];
    [self loadPage];
}

- (void)renderButtons {
    
}

- (void)loadPage {
    
    [self cleanCookieStorage];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    
    long long t = [[AQDate currentTimeStampInMillSeconds] longLongValue];
    NSString *urlstring = [NSString stringWithFormat:@"http://aqnote.com:8080/cookie.html?t=%lld", t];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSDictionary *cookieDic = @{NSHTTPCookieName : COOKIE_SID,
                                NSHTTPCookieValue : @"001",
                                NSHTTPCookieDomain : request.URL.host,
                                NSHTTPCookiePath : request.URL.path,
                                NSHTTPCookieSecure : @"",
                                NSHTTPCookieExpires : [NSDate dateWithTimeIntervalSinceNow:60 * 60],
                                @"HttpOnly" : @"true"
                                };
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDic];
    
    [cookieStorage setCookie:cookie];
    NSAssert([[cookieStorage cookies] count] > 0, @"There should be a cookie in the storage at this point");
    [self.webView loadRequest:request];
}

- (NSString*)_serializeMessage:(id)message {
  return [[NSString alloc]  initWithData:[NSJSONSerialization dataWithJSONObject:message
                                                                         options:0
                                                                           error:nil]
                                encoding:NSUTF8StringEncoding];
}

- (void)cleanCookieStorage {
    // Clear the cookie storage for demonstration purposes
    NSHTTPCookieStorage *cookieStorage =
    [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies])
    [cookieStorage deleteCookie:cookie];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView
        shouldStartLoadWithRequest:(NSURLRequest *)request
                    navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"[shouldStartLoadWithRequest] %@", request.URL);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title = [self.title stringByAppendingString:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end

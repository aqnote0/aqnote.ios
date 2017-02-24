//
//  CookieViewController.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import "AQString+AQDemo.h"
#import "AQViewController.h"
#import <UIKit/UIKit.h>
#import "AQCookieManager.h"

#define COOKIE_AQNOTE_COM @".aqnote.com"
#define COOKIE_SID @"sid"

@interface CookieViewController : AQViewController

@property(nonatomic, retain) UILabel *countdownLabel;
@property(nonatomic, retain) UIButton *killButton;
@property(nonatomic, retain) UIButton *exitButton;
@property(nonatomic, retain) UIButton *abortButton;
@property(nonatomic, retain) UIButton *replaceHttpOnlyButton;
@property(nonatomic, retain) UIButton *replaceSessionOnlyButton;

@end

@implementation CookieViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"CookieStorage";
  [self renderUI];
}

- (void)renderUI {
  
  CGFloat topHeight = [self getTopHeight] + 8;
  CGFloat betweenHeight = 64;
  
  self.countdownLabel = [[UILabel alloc] init];
  UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
  //  [UIFont boldSystemFontOfSize:12.0];
  self.countdownLabel.font = font;
  self.countdownLabel.frame = CGRectMake(8, topHeight, 208, 64);
  self.countdownLabel.backgroundColor = [UIColor blackColor];
  self.countdownLabel.text = @"No Info";
  self.countdownLabel.textColor = [UIColor whiteColor];
  self.countdownLabel.textAlignment = NSTextAlignmentLeft;
  [self.view addSubview:self.countdownLabel];

  topHeight = topHeight + betweenHeight + 8;
  self.killButton = [[UIButton alloc] init];
  [self.killButton setFrame:CGRectMake(8, topHeight, 64, 32)];
  [self.killButton setBackgroundColor:[UIColor blackColor]];
  [self.killButton setTitle:@"kill" forState:UIControlStateNormal];
  [self.killButton addTarget:self
                      action:@selector(action_kill)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.killButton];

  self.abortButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.abortButton setFrame:CGRectMake(80, topHeight, 64, 32)];
  [self.abortButton setBackgroundColor:[UIColor blackColor]];
  [self.abortButton setTitle:@"abort" forState:UIControlStateNormal];
  [self.abortButton addTarget:self
                       action:@selector(action_abort)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.abortButton];

  self.exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.exitButton setFrame:CGRectMake(152, topHeight, 64, 32)];
  [self.exitButton setBackgroundColor:[UIColor blackColor]];
  [self.exitButton setTitle:@"exit" forState:UIControlStateNormal];
  [self.exitButton addTarget:self
                      action:@selector(aciont_exit)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.exitButton];
  
  
  topHeight = topHeight + betweenHeight + 8;
  self.replaceHttpOnlyButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.replaceHttpOnlyButton setFrame:CGRectMake(8, topHeight, 64, 32)];
  [self.replaceHttpOnlyButton setBackgroundColor:[UIColor blackColor]];
  [self.replaceHttpOnlyButton setTitle:@"replace httpOnly" forState:UIControlStateNormal];
  [self.replaceHttpOnlyButton addTarget:self
                      action:@selector(aciont_replace_httpOnly)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.replaceHttpOnlyButton];
  
  self.replaceSessionOnlyButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.replaceSessionOnlyButton setFrame:CGRectMake(150, topHeight, 64, 32)];
  [self.replaceSessionOnlyButton setBackgroundColor:[UIColor blackColor]];
  [self.replaceSessionOnlyButton setTitle:@"replace SessioOnly" forState:UIControlStateNormal];
  [self.replaceSessionOnlyButton addTarget:self
                                 action:@selector(aciont_replace_sessionOnly)
                       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.replaceSessionOnlyButton];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self writeCookie];
  [self checkForMissingCookie];
}

- (void)checkForMissingCookie {
  NSHTTPCookie *cookie = [self getCookie:COOKIE_AQNOTE_COM cookieName:COOKIE_SID];

  NSString *title, *message;
  if (cookie == nil) {
    title = @"Cookie data has been lost!";
    message = @"The saved cookie is gone - because the app was killed before "
              @"the cookie storage was persisted to the disk.";
  } else {
    title = [NSString
        stringWithFormat:@"cookie[%@] data is still there.", [cookie value]];
    message =
        @"The cookie storage is persisted when the app goes to the background "
        @"or terminates gracefully. "
         "Did you let the app be killed without putting it in the background?";
  }

//  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
//                                                                           message:message
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
//                                                     style:UIAlertActionStyleDefault
//                                                   handler:nil];
//  [alertController addAction:okAction];
//  [self presentViewController:alertController animated:YES completion:nil];
}

- (void)writeCookie {
  if ([self hasCookieWrited] == false) {
    [self cleanCookieStorage];

    // Add a cookie to the cookie storage
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSDictionary *cookieDic = @{NSHTTPCookieName : COOKIE_SID,
                                NSHTTPCookieValue : @"sid",
                                NSHTTPCookieDomain : COOKIE_AQNOTE_COM,
                                NSHTTPCookiePath : @"/",
                                NSHTTPCookieSecure : [NSNumber numberWithBool:false],
                                NSHTTPCookieExpires : [NSDate dateWithTimeIntervalSinceNow:60 * 60]
                                };
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDic];
    [cookieStorage setCookie:cookie];
    NSAssert([[cookieStorage cookies] count] > 0,
             @"There should be a cookie in the storage at this point");
    [self writeCookieFlag];
  }
}

- (void)action_kill {
  pid_t pid = getpid();
  kill(pid, SIGKILL);
}

- (void)aciont_exit {
  exit(0);
}

- (void)action_abort {
  abort();
}

static int i=0;
- (void)aciont_replace_httpOnly {
  [self replaceCookie:@"cookie2"];
}

- (void)aciont_replace_sessionOnly {
  [self replaceCookie:@"_tb_token_"];
}

- (void)replaceCookie:(NSString *)cookieName {
  NSHTTPCookie *dbCookie1 = [self getCookie:@".taobao.com" cookieName:cookieName];
  
  NSString *cookieValue = [NSString stringWithFormat:@"%d", i++];
  NSDictionary *cookieDic = @{NSHTTPCookieName : cookieName,
                              NSHTTPCookieValue: cookieValue,
                              NSHTTPCookieDomain : @".taobao.com",
                              NSHTTPCookiePath: @"/",
                              NSHTTPCookieExpires : [NSDate dateWithTimeIntervalSinceNow:60 * 60]
                              };
  NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDic];
  NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
  [cookieStorage setCookie:cookie];
  
  NSHTTPCookie *dbCookie2 = [self getCookie:@".taobao.com" cookieName:cookieName];
  
  NSString *dbCookieValue =  dbCookie2.value;
  [[self countdownLabel] setText:dbCookieValue];
  
  NSLog(@"\n %@\n %@\n %@\n", dbCookie1, cookie, dbCookie2);
  NSLog(@"-----------------------------------------\n");
}

- (void)writeCookieFlag {
  [[NSUserDefaults standardUserDefaults] setBool:YES
                                          forKey:@"cookieWritedFlag"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}
- (bool)hasCookieWrited {
  return [[NSUserDefaults standardUserDefaults]
             boolForKey:@"cookieWritedFlag"] == YES;
}

- (void)cleanCookieStorage {
  // Clear the cookie storage for demonstration purposes
  NSHTTPCookieStorage *cookieStorage =
      [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (NSHTTPCookie *cookie in [cookieStorage cookies])
    [cookieStorage deleteCookie:cookie];
}

- (NSHTTPCookie *)getCookie:(NSString *)domain
                 cookieName:(NSString *)cookieName {
  NSArray<NSHTTPCookie *> *cookies =
      [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
  for (NSHTTPCookie *cookie in cookies) {
    if ([AQString endWith:domain end:[cookie domain]] &&
        [cookieName isEqualToString:[cookie name]]) {
      return cookie;
    }
  }
  return nil;
}


@end

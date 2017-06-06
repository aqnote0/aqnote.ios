//
//  NSHTTPCookieStorageTests.m
//  AQDemo
//
//  Created by madding.lip on 7/15/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NSHTTPCookieStorageTests : XCTestCase

@end

@implementation NSHTTPCookieStorageTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testWriteCookieMaxAge {
  NSDictionary *cookieProperties = [NSDictionary
      dictionaryWithObjectsAndKeys:@".domain.com", NSHTTPCookieDomain, @"/",
                                   NSHTTPCookiePath, @"cookie",
                                   NSHTTPCookieName, @"Session value",
                                   NSHTTPCookieValue, @"1",
                                   NSHTTPCookieMaximumAge, nil];
  NSDictionary *cookieProperties1 = [NSDictionary
                                    dictionaryWithObjectsAndKeys:@".domain.com", NSHTTPCookieDomain, @"/",
                                    NSHTTPCookiePath, @"cookie1",
                                    NSHTTPCookieName, @"Session value",
                                    NSHTTPCookieValue, @"0",
                                    NSHTTPCookieMaximumAge, nil];
  NSDictionary *cookieProperties2 = [NSDictionary
      dictionaryWithObjectsAndKeys:@".domain.com", NSHTTPCookieDomain, @"/",
                                   NSHTTPCookiePath, @"cookie2",
                                   NSHTTPCookieName, @"some cookie value",
                                   NSHTTPCookieValue, @"-1",
                                   NSHTTPCookieMaximumAge, nil];

  NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
  NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties1];
  NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
  
  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];
  
  NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
  NSLog(@"%@", cookies);
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
      // Put the code you want to measure the time of here.
  }];
}

@end

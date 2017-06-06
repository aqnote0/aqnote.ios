//
//  UIWebViewTests.m
//  AQDemo
//
//  Created by madding.lip on 7/22/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UIWebViewTests : XCTestCase

@end

@implementation UIWebViewTests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
}

@end

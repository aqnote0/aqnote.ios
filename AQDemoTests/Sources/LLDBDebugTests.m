//
//  LLDBDebugTest.m
//  AQDemo
//
//  Created by madding.lip on 12/7/15.
//  Copyright © 2015 madding. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LLDBDebugTests : XCTestCase

@end

@implementation LLDBDebugTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testMain {
  @autoreleasepool {
    NSInteger count = 99;
    NSString *objects = @"red";
    NSLog(@"%lu %@", (long)count, objects);
  }
}


@end

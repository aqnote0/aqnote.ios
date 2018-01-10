//
//  BoolTest.m
//  aqnoteTests
//
//  Created by Peng Li on 12/1/17.
//  Copyright © 2017 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BoolTest : XCTestCase

@end

@implementation BoolTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test001 {
    BOOL mybool = NO;
    NSNumber *number = [NSNumber numberWithBool:mybool];
    id middle = number;
    BOOL result = [(NSNumber *)middle boolValue];
    NSLog(@"[test001] %d", result);
  
  
    Boolean a = 1;
    NSLog(@"[test001] %d", a);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

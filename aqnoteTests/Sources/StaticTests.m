//
//  StaticTests.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface StaticTests : XCTestCase

@end

@implementation StaticTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test01 {
  StaticTests *tests = [StaticTests sharedInstance];
  
  tests = [StaticTests sharedInstance];
  
}

// static主要功能是隐藏
// static变量存放在静态存储区，所以默认具有持久性、初值为0
+ (id)sharedInstance {
  static id instance = nil; // static变量只初始化一次；
  if (instance == nil) {
    instance = [[self alloc] init];
  }
  return instance;
}

@end

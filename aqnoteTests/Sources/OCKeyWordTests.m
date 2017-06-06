//
//  OCKeyWordTests.m
//  AQDemo
//
//  Created by madding.lip on 8/1/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface OCKeyWordTests : XCTestCase  {
  __strong              NSString *_fString;
  __strong              NSString *_fStrongString;
  __weak                NSString *_fWeakString;
  __unsafe_unretained   NSString *_fUnsafeString;
}

@property (nonatomic, strong) NSString *string;

@property (nonatomic, strong)             NSString *strongString;
@property (nonatomic, retain)             NSString *retainString;
@property (nonatomic, weak)               NSString *wearkString;
@property (nonatomic, unsafe_unretained)  NSString *unsafeString;

@end

@implementation OCKeyWordTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_strong_retain {
  self.string = @"1";
  self.strongString = self.string;
  self.string = nil;
  NSLog(@"strongString = %@", self.strongString);
  
  self.string = @"1";
  self.strongString = self.string;
  self.string = nil;
  NSLog(@"retainStrong = %@", self.retainString);
  
  _fString = @"1";
  _fStrongString = _fString;
  _fString = nil;
  NSLog(@"_fStrongString = %@", _fStrongString);
}

// 输出不一定为1，看string有没有销毁了
- (void)test_weak_unsafe_retain {
  self.string = @"1";
  self.wearkString = self.string;
  self.string = nil;
  NSLog(@"weakString = %@", self.wearkString);
  
  self.string = @"1";
  self.unsafeString = self.string;
  self.string = nil;
  NSLog(@"unsafeString = %@", self.unsafeString);
  
  _fString = @"1";
  _fWeakString = _fString;
  _fString = nil;
  NSLog(@"_fWeakString = %@", _fWeakString);
  
  _fString = @"1";
  _fUnsafeString = _fString;
  _fString = nil;
  NSLog(@"_fUnsafeString = %@", _fUnsafeString);
}

@end

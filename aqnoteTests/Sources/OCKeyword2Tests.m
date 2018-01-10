//
//  OCKeyword2Tests.m
//  AQDemo
//
//  Created by madding.lip on 8/2/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

/**
 *  本测试例子展示property各个修饰符和对应变量的setter方法
 */
@interface OCKeyword2Tests : XCTestCase {
  NSString *_assignString;
  NSString *_retainString;
  NSString *_copyString;
  
  NSString *_nonatomicString;
  NSString *_atomicString;
  
  NSString *_strongString;
  __weak NSString *_weakString;
}

// assign: 指定setter赋值方式为直接赋值方式_f = f; default
@property(nonatomic, assign ) NSString *assignString;
// retain: 指定setter赋值方式为retain赋值 _f = [f retain]
@property(nonatomic, retain ) NSString *retainString;
// copy: 指定setter赋值方式为copy赋值 _f = [f copy];
// xcode中属性不推荐以[new|alloc|copy|mutableCopy]开头
@property(nonatomic, copy   ) NSString *pCopyString;

// nonatomic: 指定setter方法操作不需要关注线程安全，性能好；多线程会出问题; default
@property(nonatomic, assign ) NSString *nonAtomicString;
// atomic: 指定setter方式为线程安全操作:
// @try {[lock lock] TODO: } @finally { [lock unlock] }
@property(atomic, assign    ) NSString *atomicString;

// strong:; default
@property(nonatomic, strong ) NSString *strongString;
@property(nonatomic, weak   ) NSString *weakString;

@end

@implementation OCKeyword2Tests

@synthesize assignString = _assignString;
@synthesize retainString = _retainString;
@synthesize pCopyString = _copyString;
@synthesize nonAtomicString = _nonatomicString;
@synthesize atomicString = _atomicString;
@synthesize strongString = _strongString;
@synthesize weakString = _weakString;

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

// 等价于setAssignString
- (void)set_assignString:(NSString *)string {
  if(_assignString != string) {
    [_assignString release];
    _assignString = string;
    [string retain];
  }
}

// 等价于setRetainString
- (void) set_retainString:(NSString *)string {
  if(_retainString != string) {
    [_retainString release];
    _retainString = [string retain];
    [string retain];
  }
}

// 等价于setPCopyString
- (void) set_copyString:(NSString *)string {
  if(_copyString != string) {
    [_copyString release];
    _copyString = [string copy];
    [string retain];
  }
}

// 等价于setNonatomicString
- (void) set_nonatomicString:(NSString *)string {
  if(_nonatomicString != string) {
    [_nonatomicString release];
    _nonatomicString = [string retain];
    [string retain];
  }
}

// 等价于atomicString的set方法
- (void) set_atomicString:(NSString *)string {
  NSLock *lock = [[NSLock alloc] init];
  @try {
    [lock lock];
    if(_atomicString != string) {
      [_atomicString release];
      _atomicString = [string retain];
      [string retain];
    }
  } @finally {
    [lock unlock];
  }
}

- (void)testExample {
}

@end

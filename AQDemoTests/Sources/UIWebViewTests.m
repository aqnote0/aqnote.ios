//
//  UIWebViewTests.m
//  AQDemo
//
//  Created by madding.lip on 7/13/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UIWebViewTests : XCTestCase

@end

@implementation UIWebViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testISMainThread {
  dispatch_queue_t queue = dispatch_queue_create("com.aqnote.queue.task", DISPATCH_QUEUE_SERIAL);
  
  NSLock *lock = [[NSLock alloc] init];
  [lock lock];
  
  dispatch_sync(queue, ^{
    BOOL mainThread = [NSThread isMainThread];
    NSAssert(mainThread, @"%@ should be invoked in main thread.", NSStringFromSelector(_cmd));
    [lock unlock];
  });
}

- (void)testMainThread {
  dispatch_queue_t queue = dispatch_queue_create("com.aqnote.queue.task", DISPATCH_QUEUE_SERIAL);
  NSLock *lock = [[NSLock alloc] init];
  [lock lock];
  
  dispatch_sync(queue, ^{
    BOOL mainThread = [NSThread isMainThread];
    NSAssert(mainThread, @"%@ should be invoked in main thread.", NSStringFromSelector(_cmd));
    [lock unlock];
  });
}

- (void)testNSAssert {
  dispatch_queue_t queue = dispatch_queue_create("com.aqnote.queue.task", DISPATCH_QUEUE_SERIAL);
  
  NSLock *lock = [[NSLock alloc] init];
  [lock lock];
  
  dispatch_sync(queue, ^{
    BOOL mainThread = [NSThread isMainThread];
    NSAssert(mainThread, @"%@ should be invoked in main thread.", NSStringFromSelector(_cmd));
    [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [lock unlock];
  });
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

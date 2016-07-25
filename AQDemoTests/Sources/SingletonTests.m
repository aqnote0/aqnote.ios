//
//  SingletonTests.m
//  AQDemo
//
//  Created by madding.lip on 7/25/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

typedef void (^AQCompletion)(int code, NSDictionary *content);

@protocol AQSingletonProtocol <NSObject>
- (void) success;
- (void) failed;
@end

@interface AQSingleton : NSObject<AQSingletonProtocol>
+ (instancetype)sinstance;
- (void)invoke:(AQCompletion)complention;
@end

@interface SingletonTests : XCTestCase

@property(nonatomic, retain)AQSingleton *singleton;

@end

@implementation SingletonTests

- (void)setUp {
  [super setUp];
  self.singleton = [AQSingleton sinstance];
}

- (void)tearDown {
  [super tearDown];
}

// 同步调用
- (void)testSyncSingleton {
  
  
  AQCompletion completion = ^(int code, NSDictionary *content) {
    NSLog(@"code:%d,content:%@", code, content);
  };
  [self.singleton invoke:completion];
  
  [self.singleton invoke:completion];
}

/**
 *  异步调用，由于代码的单例，调用invoke耗时比较长，导致singleton类持有的block被覆盖；
 * 在第二次执行完invoke后回调结果处理时，调用到了同一个block，导致一个线程的block没执行，另一个线程block执行两次；
 * 编程时特别要注意单例对象的作耗时操作的变量持有问题；
 */
- (void)testASyncSingleton {
  
  dispatch_queue_t queue1 = dispatch_queue_create("com.aqnote.queue.test1", DISPATCH_QUEUE_SERIAL);
  dispatch_async(queue1, ^{
    AQCompletion completion = ^(int code, NSDictionary *content) { // 没运行
      NSLog(@"thread:%@,code:%d,content:%@", [NSThread currentThread], code, content);
    };
    [self.singleton invoke:completion];
  });
  
  dispatch_queue_t queue2 = dispatch_queue_create("com.aqnote.queue.test2", DISPATCH_QUEUE_SERIAL);
  dispatch_async(queue2, ^{
    AQCompletion completion = ^(int code, NSDictionary *content) { // 一个点代码运行两次
      NSLog(@"thread:%@,code:%d,content:%@", [NSThread currentThread], code, content);
    };
    [self.singleton invoke:completion];
  });
  
  NSCondition *condition = [[NSCondition alloc] init];
  [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:8]];
}

@end



@implementation AQSingleton {
  AQCompletion _complention;
}

+ (instancetype)sinstance {
  static id sinstance = nil;
  if(sinstance == nil) {
    sinstance = [[AQSingleton alloc] init];
  }
  return sinstance;
}

- (void)invoke:(AQCompletion)complention {
  _complention = complention;
  
  NSLog(@"%@ complention:%@", NSStringFromSelector(_cmd), complention);
  sleep(3); // simulate running
  
  [self success];
}

- (void) success {
  NSLog(@"%@ success, %@", NSStringFromSelector(_cmd), _complention);
  _complention(0, @{@"key":_complention});
}

- (void) failed {
  NSLog(@"%@ failed", NSStringFromSelector(_cmd));
  _complention(1, @{@"key":_complention});
}



@end
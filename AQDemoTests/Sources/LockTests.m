//
//  LockTest.m
//  AQDemo
//
//  Created by madding.lip on 7/4/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>
#include <pthread.h>

@interface TestObj : NSObject
- (void)method1;
- (void)method2;
@end

@implementation TestObj

- (void)method1 {
  NSLog(@"%@", NSStringFromSelector(_cmd));
  sleep(3);
}

- (void)method2 {
  NSLog(@"%@", NSStringFromSelector(_cmd));
  sleep(1);
}
@end

@interface LockTests : XCTestCase

@end

@implementation LockTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

// 使用NSLock来实现锁
- (void)test_01 {
  //主线程中
  NSCondition *condition = [[NSCondition alloc] init];

  TestObj *obj = [[TestObj alloc] init];
  NSLock *lock = [[NSLock alloc] init];

  //线程1
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [lock lock];
                   [obj method1];
                   [lock unlock];
                 });

  sleep(1);  //以保证让线程2的代码后执行
  //线程2
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{

                   [lock lock];
                   [obj method2];
                   [lock unlock];

                   [condition lock];
                   [condition signal];
                   [condition unlock];
                 });

  [condition lock];
  [condition wait];
  [condition unlock];
}

// 使用synchronized关键字构建的锁
- (void)test_02 {
  NSCondition *condition = [[NSCondition alloc] init];

  TestObj *obj = [[TestObj alloc] init];

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   @synchronized(obj) {
                     [obj method1];
                   }

                 });

  sleep(1);

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   @synchronized(obj) {
                     [obj method2];
                   }

                   [condition lock];
                   [condition signal];
                   [condition unlock];
                 });

  [condition lock];
  [condition wait];
  [condition unlock];
}

// 使用C语言的pthread_mutex_t实现的锁
- (void)test_03 {
  NSCondition *condition = [[NSCondition alloc] init];

  TestObj *obj = [[TestObj alloc] init];

  __block pthread_mutex_t mutex;
  pthread_mutex_init(&mutex, NULL);

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   pthread_mutex_lock(&mutex);
                   [obj method1];
                   pthread_mutex_unlock(&mutex);

                 });

  sleep(1);

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   pthread_mutex_lock(&mutex);
                   [obj method2];
                   pthread_mutex_unlock(&mutex);

                   [condition lock];
                   [condition signal];
                   [condition unlock];
                 });

  [condition lock];
  [condition wait];
  [condition unlock];
}

// 使用GCD信号机制来实现锁
- (void)test_04 {
  NSCondition *condition = [[NSCondition alloc] init];

  TestObj *obj = [[TestObj alloc] init];

  dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                   [obj method1];
                   dispatch_semaphore_signal(semaphore);

                 });

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   dispatch_semaphore_signal(semaphore);
                   [obj method2];
                   dispatch_semaphore_signal(semaphore);

                   [condition lock];
                   [condition signal];
                   [condition unlock];
                 });

  [condition lock];
  [condition wait];
  [condition unlock];
}
@end

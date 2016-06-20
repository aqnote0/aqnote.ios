//
//  GCDTests.m
//  YDDemo
//
//  Created by madding.lip on 11/24/15.
//  Copyright © 2015 madding. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GCDTests : XCTestCase

@end

@implementation GCDTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test01_DeadLock {
  dispatch_queue_t queue = dispatch_queue_create("com.madding.queue.task", DISPATCH_QUEUE_SERIAL);
  NSLog(@"1");
  dispatch_sync(queue, ^ {
    NSLog(@"2");
    dispatch_sync(queue, ^ {
      NSLog(@"3");
    });
    NSLog(@"4");
  });
}

/**
 *  区别于test01_NoDeadLock
    1.sync2是sync1 block中的一部分任务
    2.sync2在执行时sync1必然已经添加到queue中，而queue时串行处理block
    3.导致sync1的block没执行完，sync2的block又添加不进去，无法执行；导致死锁
 */
- (void)test01_DeadLock1 {
  dispatch_queue_t queue = dispatch_queue_create("com.madding.queue.task", DISPATCH_QUEUE_SERIAL);
  NSLog(@"1");
  dispatch_async(queue, ^{  // sync1
    NSLog(@"2");
    dispatch_sync(queue, ^{  // sync2
      NSLog(@"3");
    });
    NSLog(@"4");
  });
  NSLog(@"5");
}

- (void)test01_NoDeadLock {
  dispatch_queue_t queue = dispatch_queue_create("com.madding.queue.task", DISPATCH_QUEUE_SERIAL);
  NSLog(@"1");
  dispatch_sync(queue, ^{
    NSLog(@"2");
    dispatch_async(queue, ^{
      NSLog(@"3");
    });
    NSLog(@"4");
  });
  NSLog(@"5");
}

/**
 *  等价于test03_DeadLock
 */
- (void)test02_DeadLock {
  NSLog(@"1");
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSLog(@"2");
  });
  NSLog(@"3");
}

/**
 *  死锁分析：
   1.mainQueue是串行队列，sync是向mainQueue添加block，同时等待block执行完才返回；
   2.对于sync1，往mainQueue中添加block，等待block执行完返回
   3.对于sync2，同样要往mainQueue中添加block，并等待block执行完才返回
   4.此时queue中只有一个block，另一个必须等待第一个queue执行完才能添加；
   5.而sync2是sync1中的block的一部分任务
   6.导致sync1等待sync2执行完成才能执行下一个queue，而sync2有要等待sync1执行结束才能执行；死锁
 */
- (void)test03_DeadLock {
  NSLog(@"1");
  dispatch_sync(dispatch_get_main_queue(), ^{  // sync1
    dispatch_sync(dispatch_get_main_queue(), ^{  // sync2
      NSLog(@"2");
    });
  });
  NSLog(@"3");
}

/**
 *  死锁分析：
    1.sync1要求在其之前的block先运行，在其之后的block之后运行
    2.sync1之前无任务，所以sync1开始运行
    3.在sync1的block运行过程中，其中有sync2要求往block中同步添加一个block并等待其结束
    4.由于queue要求其之后添加的任务必须之后运行，导致死锁
 */
- (void)test04_DeadLock {
  dispatch_queue_t queue = dispatch_queue_create("com.madding.queue.task", DISPATCH_QUEUE_CONCURRENT);
  NSLog(@"1");
  dispatch_barrier_async(queue, ^{ // sync1
    NSLog(@"2");
    dispatch_sync(queue, ^{  // sync2
      NSLog(@"3");
    });
    NSLog(@"6");
  });
  NSLog(@"7");
}

- (void)test05_NoDeadLock {
  dispatch_queue_t queue = dispatch_queue_create("com.madding.queue.task", DISPATCH_QUEUE_CONCURRENT);
  NSLog(@"1");
  dispatch_sync(queue, ^{
    NSLog(@"2");
    dispatch_sync(queue, ^{
      NSLog(@"3");
      dispatch_sync(queue, ^{
        NSLog(@"4");
      });
    NSLog(@"5");
    });
    NSLog(@"6");
  });
  NSLog(@"7");
}

- (void)test06_NoDeadLock {
  dispatch_queue_t queue = dispatch_queue_create("com.madding.queue.task", DISPATCH_QUEUE_CONCURRENT);
  dispatch_queue_t queue1 = dispatch_queue_create("com.madding.queue.task1", DISPATCH_QUEUE_CONCURRENT);
  NSLog(@"1");
  for(int i=0; i<100; i++) {
  dispatch_barrier_async(queue, ^{
    NSLog(@"---------%d", i);
    NSLog(@"2");
    dispatch_sync(queue1, ^{
      NSLog(@"3");
      dispatch_async(queue1, ^{
        NSLog(@"4");
      });
    NSLog(@"5");
    });
    NSLog(@"6");
  });
  }
  NSLog(@"7");
}

- (void)test07_NoDeadLock {
  dispatch_queue_t queue = dispatch_queue_create("com.madding.queue.task", DISPATCH_QUEUE_CONCURRENT);
  dispatch_queue_t queue1 = dispatch_queue_create("com.madding.queue.task1", DISPATCH_QUEUE_CONCURRENT);
  NSLog(@"1");
  for(int i=0; i<100; i++) {
  dispatch_barrier_async(queue, ^{
    NSLog(@"---------%d", i);
    NSLog(@"2");
    dispatch_sync(queue1, ^{
      NSLog(@"3");
      dispatch_async(queue1, ^{
        NSLog(@"4");
      });
      dispatch_sync(queue1, ^{
        NSLog(@"a");
        dispatch_sync(queue1, ^{
          NSLog(@"b");
        });
      });
    NSLog(@"5");
    });
    NSLog(@"6");
  });
  }
  NSLog(@"7");
}

- (void)test08_limit512 {
  dispatch_queue_t queue = dispatch_queue_create("com.madding.queue.concurrent", DISPATCH_QUEUE_CONCURRENT);  // 8 threads
  queue = dispatch_queue_create("com.madding.queue.concurrent", DISPATCH_QUEUE_SERIAL);  // 1 threads
  
  for(int i=0; i < 512; i++) {
    dispatch_async(queue, ^{
      NSLog(@"begin i=%d", i);
      sleep(10);
      NSLog(@"end i=%d", i);
    });
  }
  
  XCTAssert(true, @"failure");
}

@end

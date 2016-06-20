//
//  NSArrayPerfTest.m
//  YDDemo
//
//  Created by madding.lip on 12/15/15.
//  Copyright © 2015 madding. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AQFoundation/YDDate.h>

@interface NSArrayPerfTest : XCTestCase

@end

@implementation NSArrayPerfTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test001_ {
  NSNumber *begin = [YDDate currentTimeStampInMillSeconds];
  NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
  for(int i=0; i < 100000; i++) {
    [mutableArray addObject:[NSNumber numberWithInt:i]];
  }
  NSNumber *end = [YDDate currentTimeStampInMillSeconds];
  long long between = [end longLongValue] - [begin longLongValue];
  NSLog(@"insert 100k date, time cost: %lld", between);
  
  begin = [YDDate currentTimeStampInMillSeconds];
  NSArray *array = [mutableArray copy];
  end = [YDDate currentTimeStampInMillSeconds];
  between = [end longLongValue] - [begin longLongValue];
  NSLog(@"copy 100k from mutable, time cost: %lld", between);
  
  begin = [YDDate currentTimeStampInMillSeconds];
  for(int i=0; i< [array count];i++) {
    [array objectAtIndex:i];
  }
  end = [YDDate currentTimeStampInMillSeconds];
  between = [end longLongValue] - [begin longLongValue];
  NSLog(@"index 100k date, time cost: %lld", between);
  
  XCTAssert(true, @"success");
}


@end

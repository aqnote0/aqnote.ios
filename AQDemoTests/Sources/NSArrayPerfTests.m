//
//  NSArrayPerfTest.m
//  AQDemo
//
//  Created by madding.lip on 12/15/15.
//  Copyright © 2015 madding. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AQFoundation/AQDate.h>

@interface NSArrayPerfTests : XCTestCase

@end

@implementation NSArrayPerfTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test001_ {
  NSNumber *begin = [AQDate currentTimeStampInMillSeconds];
  NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
  for(int i=0; i < 100000; i++) {
    [mutableArray addObject:[NSNumber numberWithInt:i]];
  }
  NSNumber *end = [AQDate currentTimeStampInMillSeconds];
  long long between = [end longLongValue] - [begin longLongValue];
  NSLog(@"insert 100k date, time cost: %lld", between);
  
  begin = [AQDate currentTimeStampInMillSeconds];
  NSArray *array = [mutableArray copy];
  end = [AQDate currentTimeStampInMillSeconds];
  between = [end longLongValue] - [begin longLongValue];
  NSLog(@"copy 100k from mutable, time cost: %lld", between);
  
  begin = [AQDate currentTimeStampInMillSeconds];
  for(int i=0; i< [array count];i++) {
    [array objectAtIndex:i];
  }
  end = [AQDate currentTimeStampInMillSeconds];
  between = [end longLongValue] - [begin longLongValue];
  NSLog(@"index 100k date, time cost: %lld", between);
  
  XCTAssert(true, @"success");
}


@end

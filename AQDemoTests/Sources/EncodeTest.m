//
//  EncodeTest.m
//  YDTestDemo
//
//  Created by madding.lip on 12/16/15.
//  Copyright © 2015 madding. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface EncodeTest : XCTestCase

@end

@implementation EncodeTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_encode {
  NSLog(@"int        : %s", @encode(int));
  NSLog(@"float      : %s", @encode(float));
  NSLog(@"float *    : %s", @encode(float*));
  NSLog(@"char       : %s", @encode(char));
  NSLog(@"char *     : %s", @encode(char *));
  NSLog(@"BOOL       : %s", @encode(BOOL));
  NSLog(@"void       : %s", @encode(void));
  NSLog(@"void *     : %s", @encode(void *));
  
  NSLog(@"NSObject * : %s", @encode(NSObject *));
  NSLog(@"NSObject   : %s", @encode(NSObject));
  NSLog(@"[NSObject] : %s", @encode(typeof([NSObject class])));
  NSLog(@"NSError ** : %s", @encode(typeof(NSError **)));
  
  int intArray[5] = {1, 2, 3, 4, 5};
  NSLog(@"int[]      : %s", @encode(typeof(intArray)));
  
  float floatArray[3] = {0.1f, 0.2f, 0.3f};
  NSLog(@"float[]    : %s", @encode(typeof(floatArray)));
  
  typedef struct _struct {
    short a;
    long long b;
    unsigned long long c;
  } Struct;
  NSLog(@"struct     : %s", @encode(typeof(Struct)));
}

@end

//
//  EncodeTest.m
//  AQTestDemo
//
//  Created by madding.lip on 12/16/15.
//  Copyright © 2015 madding. All rights reserved.
//

#import <XCTest/XCTest.h>



@interface EncodeTests : XCTestCase

@end

@implementation EncodeTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_encode {
  
  NSLog(@"void              : %s", @encode(void));
  NSLog(@"void *            : %s", @encode(void *));
  
  NSLog(@"bool              : %s", @encode(bool));
  NSLog(@"bool *            : %s", @encode(bool *));
  
  NSLog(@"char              : %s", @encode(char));
  NSLog(@"unsigned char     : %s", @encode(unsigned char));
  NSLog(@"Boolean           : %s", @encode(Boolean));
  NSLog(@"char *            : %s", @encode(char *));
  NSLog(@"unsigned char *   : %s", @encode(unsigned char *));
  
  NSLog(@"int               : %s", @encode(int));
  NSLog(@"unsigned int      : %s", @encode(unsigned int));
  NSLog(@"int *             : %s", @encode(int *));
  
  NSLog(@"float             : %s", @encode(float));
  NSLog(@"float *           : %s", @encode(float *));
  
  NSLog(@"BOOL              : %s", @encode(BOOL));
  
  NSLog(@"Class             : %s", @encode(typeof(Class)));
  NSLog(@"NSObject          : %s", @encode(NSObject));
  NSLog(@"NSObject *        : %s", @encode(NSObject *));
  NSLog(@"NSObject **       : %s", @encode(typeof(NSObject **)));
  
  int intArray[5] = {1, 2, 3, 4, 5};
  NSLog(@"int[]             : %s", @encode(typeof(intArray)));
  
  float floatArray[3] = {0.1f, 0.2f, 0.3f};
  NSLog(@"float[]           : %s", @encode(typeof(floatArray)));
  
  struct udt {
    short a;
    long long b;
    unsigned long long c;
  };
  typedef struct udt Udt;
  NSLog(@"struct            : %s", @encode(typeof(Udt)));
}

@end

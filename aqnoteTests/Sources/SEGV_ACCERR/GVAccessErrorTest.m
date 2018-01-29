//
//  GlobalVariableAccessErrorTest.m
//  aqnoteTests
//
//  Created by Peng Li on 1/29/18.
//  Copyright © 2018 Peng Li. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GVtestDO.h"
#import "GVTestInstance.h"

@interface MainDo : NSObject

@property(nonatomic, strong) NSString *useAttribute;

+ (instancetype)sharedInstance;

@end

@implementation MainDo

+ (instancetype)sharedInstance {
  static MainDo *sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MainDo alloc] init];
  });
  
  return sharedInstance;
}

@end


@interface GVAccessErrorTest : XCTestCase

@end

@implementation GVAccessErrorTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCase1 {
  
  
  
  
  
}

- (void)test_async_use_GVTestDO {
  for(int time=0; time<1; time++) {
    
    NSCondition *condition = [[NSCondition alloc] init];
    
    MainDo *mainDo = [MainDo sharedInstance];
    
    dispatch_queue_t queue1 = dispatch_queue_create("com.aqnote.queue.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    for(int i=0; i<1000; i++) {
      dispatch_async(queue1, ^(){
        NSLog(@"[aqnote] block1");
        GVTestDO *gvTestDO = [[GVTestDO alloc] init];
        gvTestDO.attribute1 = [NSString stringWithFormat:@"%@%i", @"a", i];
        [[GVTestInstance sharedInstance] execute:gvTestDO];
        dispatch_async(queue1, ^{
          mainDo.useAttribute = [GVTestInstance sharedInstance].attribute;
          NSLog(@"[aqnote] block1 useAttribute=%@", mainDo.useAttribute);
        });
      });
      
      dispatch_async(queue1, ^(){
        NSLog(@"[aqnote] block2");
        GVTestDO *gvTestDO = [[GVTestDO alloc] init];
        gvTestDO.attribute1 = [NSString stringWithFormat:@"%@%i", @"b", i];
        [[GVTestInstance sharedInstance] execute:gvTestDO];
        dispatch_async(queue1, ^{
          mainDo.useAttribute = [GVTestInstance sharedInstance].attribute;
          NSLog(@"[aqnote] block2 useAttribute=%@", mainDo.useAttribute);
        });
      });
//
//      dispatch_async(queue, ^(){
//        mainDo.useAttribute = [GVTestInstance sharedInstance].attribute;
//        sleep(1);
//      });
//
//      NSLog(@"useAttribute=%@", mainDo.useAttribute);
//      sleep(1);
    }
    
    NSLog(@"useAttribute=%@", mainDo.useAttribute);
    
    [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
  }
}


@end

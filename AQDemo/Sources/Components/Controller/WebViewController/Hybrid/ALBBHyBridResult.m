//
//  AQHyBridResult.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQHyBridResult.h"

#import "AQJSON.h"

@implementation AQHyBridResult
+ (instancetype)build:(NSInteger)code {
  return [AQHyBridResult build:code message:nil data:nil];
}
+ (instancetype)build:(NSInteger)code message:(NSString *)message data:(NSDictionary *)data {
  AQHyBridResult *error = [[AQHyBridResult alloc] init];
  error.code = [NSNumber numberWithInteger:code];
  error.message = message;
  error.data = data;
  return error;
}
- (NSString *)json {
  return [AQJSON objectToJsonString:self];
}
@end
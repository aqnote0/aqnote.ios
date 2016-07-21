//
//  AQString+AQDemo.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import "AQString+AQDemo.h"

@implementation AQString (AQDemo)

+ (BOOL) endWith:(NSString *)first end:(NSString *)end {
  if(end == nil) return NO;
  
  NSInteger total = [first length];
  NSInteger len = [end length];
  
  if(total < len) {
    return NO;
  }
  
  NSString *endSub = [first substringFromIndex:(total - len)];
  return [end isEqualToString:endSub];
}

@end

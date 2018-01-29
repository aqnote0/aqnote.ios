//
//  GVTestInstance.m
//  aqnoteTests
//
//  Created by Peng Li on 1/29/18.
//  Copyright © 2018 Peng Li. All rights reserved.
//

#import "GVTestInstance.h"

@implementation GVTestInstance

+ (instancetype)sharedInstance {
  static GVTestInstance *sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[GVTestInstance alloc] init];
  });
  
  return sharedInstance;
}


- (void)execute:(GVTestDO *)gvTestDO {
  self.attribute = gvTestDO.attribute1;
}

@end

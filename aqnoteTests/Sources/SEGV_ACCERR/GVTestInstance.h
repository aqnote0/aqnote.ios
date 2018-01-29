//
//  GVTestInstance.h
//  aqnoteTests
//
//  Created by Peng Li on 1/29/18.
//  Copyright © 2018 Peng Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVTestDO.h"

@interface GVTestInstance : NSObject<Callback>

+ (instancetype) sharedInstance;

@property(nonatomic, strong) NSString *attribute;

@end

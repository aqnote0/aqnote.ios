//
//  GVtestDO.h
//  aqnote
//
//  Created by Peng Li on 1/29/18.
//  Copyright © 2018 Peng Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVTestDO;

@protocol Callback

- (void)execute:(GVTestDO *)gvTestDO;

@end

@interface GVTestDO : NSObject

@property(nonatomic, copy) NSString *attribute1;
@property(nonatomic, copy) NSString *attribute2;
@property(nonatomic, copy) NSString *attribute3;

@property(nonatomic, copy) id<Callback> delegate;

@end


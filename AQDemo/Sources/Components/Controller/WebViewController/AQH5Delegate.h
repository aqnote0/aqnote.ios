//
//  AQH5Delegate.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol AQH5Delegate <NSObject>

@required
- (void)viewControllerCallback:(UIViewController *)controller params:(NSDictionary *)params;

@end
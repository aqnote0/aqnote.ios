//
//  PSTTestObject.m
//  PSTFoundationBenchmark
//
//  Created by Peter Steinberger on 05/12/13.
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//

#import "YDTestObject.h"

@implementation YDTestObject

- (id)copyWithZone:(NSZone *)zone {
    YDTestObject *copy = [[YDTestObject alloc] init];
    return copy;
}

@end

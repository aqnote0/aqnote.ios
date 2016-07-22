//
//  PSTTestObject.m
//  PSTFoundationBenchmark
//
//  Created by Peter Steinberger on 05/12/13.
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

- (id)copyWithZone:(NSZone *)zone {
    TestObject *copy = [[TestObject alloc] init];
    return copy;
}

@end

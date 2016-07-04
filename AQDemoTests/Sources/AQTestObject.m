//
//  PSTTestObject.m
//  PSTFoundationBenchmark
//
//  Created by Peter Steinberger on 05/12/13.
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//

#import "AQTestObject.h"

@implementation AQTestObject

- (id)copyWithZone:(NSZone *)zone {
    AQTestObject *copy = [[AQTestObject alloc] init];
    return copy;
}

@end

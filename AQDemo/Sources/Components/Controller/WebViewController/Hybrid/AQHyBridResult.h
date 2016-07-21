//
//  AQHyBridResult.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AQHyBridResult : NSObject
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDictionary *data;

+ (instancetype)build:(NSInteger)code;

- (NSString *)json;
@end
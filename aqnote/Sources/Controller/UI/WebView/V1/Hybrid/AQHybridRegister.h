//
//  AQHybridRegister.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQHybridService.h"

@interface AQHybridRegister : NSObject
/** 注册 */
+ (void)registerService:(AQHybridService *)service hostname:(NSString *)hostname;
/** 注销 */
+ (void)unregisterService:(NSString *)hostname;
/** 服务 */
+ (NSDictionary *)services;
/** host */
+ (NSDictionary *)hostNames;
@end

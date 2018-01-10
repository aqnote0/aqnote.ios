//
//  AQCookieManager.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AQCookieManager : NSObject

// 读取
+ (NSString *)cookieForName:(NSString *)name;

// 删除
+ (void)deleteCookieForName:(NSString *)key;

// 保存cookie
+ (void)saveCookies:(NSArray *)cookiesMap;

// 重置 
+ (void)resetCookies;

@end

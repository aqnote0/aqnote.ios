//
//  AQCookieManager.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQCookieManager.h"

#import <AQFoundation/AQJSON.h>


@implementation AQCookieManager

#pragma mark query
+ (NSDictionary *)cookiePropertiesWithCookieString:(NSString *)cookieString {
  NSMutableDictionary *cookieMap = [NSMutableDictionary dictionary];
  NSArray *cookieKeyValueStrings =
      [cookieString componentsSeparatedByString:@";"];
  for (NSString *cookieKeyValueString in cookieKeyValueStrings) {
    // fixbug: 修复无法处理"key=value=value;"value中有"="的问题
    NSRange sepRange = [cookieKeyValueString rangeOfString:@"="];
    if (sepRange.location != NSNotFound && sepRange.location >= 1) {
      NSRange rangOfKey = NSMakeRange(0, sepRange.location);
      NSString *key = [cookieKeyValueString substringWithRange:rangOfKey];
      NSString *value = [cookieKeyValueString
          substringFromIndex:sepRange.location + sepRange.length];
      key = [key stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
      value = [value stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
      [cookieMap setObject:value forKey:key];
    }
  }
  return cookieMap;
}

+ (NSDictionary *)standardizeCookieProperties:(NSDictionary *)cookieProperties {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  for (NSString *key in [cookieProperties allKeys]) {
    NSString *value = cookieProperties[key];
    NSString *uppercaseKey =
        [key uppercaseString];  //主要是排除命名不规范的问题

    if ([uppercaseKey isEqualToString:@"DOMAIN"]) {
      if (![value hasPrefix:@"."] && ![value hasPrefix:@"www"]) {
        value = [NSString stringWithFormat:@".%@", value];
      }
      [result setObject:value forKey:NSHTTPCookieDomain];
    } else if ([uppercaseKey isEqualToString:@"VERSION"]) {
      [result setObject:value forKey:NSHTTPCookieVersion];
    } else if ([uppercaseKey isEqualToString:@"MAX-AGE"] ||
               [uppercaseKey isEqualToString:@"MAXAGE"]) {
      [result setObject:value forKey:NSHTTPCookieMaximumAge];
    } else if ([uppercaseKey isEqualToString:@"PATH"]) {
      [result setObject:value forKey:NSHTTPCookiePath];
    } else if ([uppercaseKey isEqualToString:@"ORIGINURL"]) {
      [result setObject:value forKey:NSHTTPCookieOriginURL];
    } else if ([uppercaseKey isEqualToString:@"PORT"]) {
      [result setObject:value forKey:NSHTTPCookiePort];
    } else if ([uppercaseKey isEqualToString:@"SECURE"] ||
               [uppercaseKey isEqualToString:@"ISSECURE"]) {
      [result setObject:value forKey:NSHTTPCookieSecure];
    } else if ([uppercaseKey isEqualToString:@"COMMENT"]) {
      [result setObject:value forKey:NSHTTPCookieComment];
    } else if ([uppercaseKey isEqualToString:@"COMMENTURL"]) {
      [result setObject:value forKey:NSHTTPCookieCommentURL];
    } else if ([uppercaseKey isEqualToString:@"EXPIRES"]) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.locale =
          [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
      dateFormatter.dateFormat = @"EEE, dd-MMM-yyyy HH:mm:ss zzz";
      [result setObject:[dateFormatter dateFromString:value]
                 forKey:NSHTTPCookieExpires];
    } else if ([uppercaseKey isEqualToString:@"DISCART"]) {
      [result setObject:value forKey:NSHTTPCookieDiscard];
    } else if ([uppercaseKey isEqualToString:@"NAME"]) {
      [result setObject:value forKey:NSHTTPCookieName];
    } else if ([uppercaseKey isEqualToString:@"VALUE"]) {
      [result setObject:value forKey:NSHTTPCookieValue];
    } else {
      [result setObject:key forKey:NSHTTPCookieName];
      [result setObject:value forKey:NSHTTPCookieValue];
    }
  }

  // 由于cookieWithProperties:方法properties中不能没有NSHTTPCookiePath，
  // 所以这边需要确认下，如果没有则默认为@"/"
  if (![result objectForKey:NSHTTPCookiePath]) {
    [result setObject:@"/" forKey:NSHTTPCookiePath];
  }
  return result;
}

+ (NSDictionary *)cookiesWithCookieString:(NSString *)cookieString {
  return [self standardizeCookieProperties:
                   [self cookiePropertiesWithCookieString:cookieString]];
}

#pragma mark interface
+ (NSString *)cookieForName:(NSString *)name {
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (NSHTTPCookie *cookie in [storage cookies]) {
    if ([cookie.name isEqualToString:name]) return cookie.value;
  }
  return nil;
}

+ (void)deleteCookieForName:(NSString *)key {
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (NSHTTPCookie *cookie in [storage cookies]) {
    if ([cookie.name isEqualToString:key]) [storage deleteCookie:cookie];
  }
}

+ (void)saveCookies:(NSArray *)cookiesArray {
  NSMutableArray<NSDictionary *> *cookies = [NSMutableArray array];
  for (NSString *string in cookiesArray) {
    [cookies addObject:[self cookiesWithCookieString:string]];
  }

  // save
  for (NSDictionary *cookieDic in cookies) {
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
  }
}

+ (void)resetCookies {
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  NSArray<NSHTTPCookie *> *cookies = [storage cookies];
  for (NSHTTPCookie *cookie in cookies) {
    [storage deleteCookie:cookie];
  }
}

@end

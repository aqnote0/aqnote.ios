//
//  AQUtils.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQUtils.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <objc/runtime.h>

#import <AQFoundation/AQLogger.h>
#import <AQFoundation/AQBundle.h>
#import <AQFoundation/MBProgressHUD.h>

#import "AQToastView.h"

#define kActionKeyName2 @"action"
#define kActionKeyName @"_ap_action"

#define loginUrlDaily @"http://login.waptest.taobao.com/minisdk/login.htm"
#define loginUrlPreRelease @"http://login.wapa.taobao.com/minisdk/login.htm"
#define loginUrlRelease @"http://login.m.taobao.com/minisdk/login.htm"

@implementation AQUtils

+ (UIImage *)createImageWithColor:(UIColor *)color {
  return [self createImageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
  CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return theImage;
}

+ (UIColor *)colorWithRGBA:(int)color {
  int red = (color & 0xff000000) >> 24;
  int green = (color & 0x00ff0000) >> 16;
  int blue = (color & 0x0000ff00) >> 8;
  int alpha = (color & 0x000000ff);
  return [[UIColor alloc] initWithRed:red / 255.f
                                green:green / 255.f
                                 blue:blue / 255.f
                                alpha:alpha / 255.f];
}

+ (NSDictionary *)queryParamsOfUrl:(NSURL *)url {
  if (!url.query) {
    return nil;
  }

  NSMutableDictionary *ret = [NSMutableDictionary dictionary];
  NSArray *keyValuePairs = [url.query componentsSeparatedByString:@"&"];
  for (id kv in keyValuePairs) {
    NSArray *kvPair = [kv componentsSeparatedByString:@"="];
    if ([kvPair count] < 2) {
      continue;
    }
    NSString *key = [kvPair objectAtIndex:0];
    NSString *value = [kvPair objectAtIndex:1];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CFStringRef origStr =
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
            NULL, (CFStringRef)(value), CFSTR(""), kCFStringEncodingUTF8);
#pragma clang diagnostic pop
    
    [ret setValue:(__bridge NSString *)(origStr) forKey:key];
    CFRelease(origStr);
  }

  return ret;
}

+ (void)toast:(NSString *)text {
  [AQToastView presentToastWithInView:[AQUtils getCurrentView] text:text duration:3];
}

+ (void)toast:(UIView *)view text:(NSString *)text {
  [AQToastView presentToastWithInView:view text:text duration:3];
}

//获取当前屏幕显示的view
+ (UIView *)getCurrentView {  
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  if (window.windowLevel != UIWindowLevelNormal) {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *tmpWin in windows) {
      if (tmpWin.windowLevel == UIWindowLevelNormal) {
        window = tmpWin;
        break;
      }
    }
  }

  return [[window subviews] objectAtIndex:0];
}

+ (BOOL)iOS7OrLater {
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
    return YES;
  }
  return NO;
}


@end

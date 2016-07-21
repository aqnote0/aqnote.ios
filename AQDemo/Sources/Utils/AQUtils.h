//
//  AQUtils.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AQUtils : NSObject

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIColor *)colorWithRGBA:(int)color;

+ (NSDictionary *)queryParamsOfUrl:(NSURL*)url;

+ (void) toast:(NSString *)text;

+ (BOOL)iOS7OrLater;

@end

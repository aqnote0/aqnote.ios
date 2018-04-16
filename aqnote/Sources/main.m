//
//  main.m
//  iosdev
//
//  Created by madding on 6/8/15.
//  Copyright (c) 2015 madding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AQFoundation/AQBundle.h>
#import <AQFoundation/AQDate.h>
#import <AQFoundation/AQString.h>
#import "AppDelegate.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    // ios 同时只能运行64个线程，主线程占1，其他线程最多63个
//    for(int i=0; i < 512; i++) {
//      dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"begin i=%d", i);
//        sleep(10);
//        NSLog(@"end i=%d", i);
//      });
//    }
   
    NSString *homePath = [NSBundle mainBundle].bundlePath;
    homePath = [homePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    
    NSURL *filePath = [AQBundle bundleFileURL:@"id" fileType:@"jpg" bundleName:@"aqnote"];
    
    NSError *error = nil;
    NSString *path = [filePath path];
    NSDictionary<NSString *, id> * attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    
    NSLog(@"%@", attrs);
    NSDate * modifyDate = [attrs fileModificationDate];
    [attrs fileSystemFileNumber];
    
    NSTimeInterval ts = [modifyDate timeIntervalSince1970];
    long long digits = (long long)ts;
    int decimalDigits = (int)(fmod(ts, 1) * 1000);
    long long timestamp = (digits * 1000) + decimalDigits;
    
    NSLog(@"%lld", timestamp);
    
    NSString *delegateClassName = NSStringFromClass([AppDelegate class]);
    return UIApplicationMain(argc, argv, nil, delegateClassName);
  }
}


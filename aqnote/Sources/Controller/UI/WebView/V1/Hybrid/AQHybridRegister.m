//
//  AQHybridRegister.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQHybridRegister.h"

#import <AQFoundation/AQSafeMutableDictionary.h>

@interface AQHybridRegister ()
@property (nonatomic, strong) AQSafeMutableDictionary <NSString *, AQHybridService *> *serviceByClassName;
@property (nonatomic, strong) AQSafeMutableDictionary <NSString *, NSString *> *classNameByPluginName;
@end

@implementation AQHybridRegister

#pragma mark life cycle
+ (AQHybridRegister *)sharedInstance {
  static AQHybridRegister *sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[AQHybridRegister alloc] init];
  });
  
  return sharedInstance;
}

- (instancetype)init {
    if (self) {
        self.serviceByClassName = [[AQSafeMutableDictionary alloc] init];
        self.classNameByPluginName = [[AQSafeMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark impl
- (void)registerService:(AQHybridService *)service hostname:(NSString *)hostname {
    if (!service || !hostname) return;
    
    NSString *className = NSStringFromClass([service class]);
    [self.classNameByPluginName setObject:className forKey:hostname];
    [self.serviceByClassName setObject:service forKey:className];
    [service pInitialize];
}

- (void)unregisterService:(NSString *)hostname {
    NSString *className = [self.classNameByPluginName objectForKey:hostname];
    if (!className) return;
    [[self.serviceByClassName objectForKey:className] pDestory];
    [self.serviceByClassName removeObjectForKey:className];
    [self.classNameByPluginName removeObjectForKey:hostname];
}

#pragma mark interface
+ (void)registerService:(AQHybridService *)service hostname:(NSString *)hostname {
    [[AQHybridRegister sharedInstance] registerService:service hostname:hostname];
}

+ (void)unregisterService:(NSString *)hostname {
    [[AQHybridRegister sharedInstance] unregisterService:hostname];
}

+ (NSDictionary *)services {
    return [AQHybridRegister sharedInstance].serviceByClassName.copy;
}

+ (NSDictionary *)hostNames {
    return [AQHybridRegister sharedInstance].classNameByPluginName.copy;
}

@end

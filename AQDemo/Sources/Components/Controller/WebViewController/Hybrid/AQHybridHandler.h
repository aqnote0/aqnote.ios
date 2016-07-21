//
//  AQHybridHandler.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQHybridContext.h"

extern NSString *createScript(NSString *callback, NSString *requestId, NSString *data);

@interface AQHybridParam : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, copy) NSDictionary *param;
@end

/**
 处理满足该模式的URL Schema: hybrid://className:requestId/methodName?parameters 调用对应的方法
 */
@interface AQHybridHandler : NSObject
+ (BOOL)isMatch:(NSURLRequest *)request;
+ (void)handle:(NSURLRequest *)request context:(AQHybridContext *)context;
@end

typedef enum {
  NOT_FOUND = 0,    //方法找不到
  PARAM_ERROR = 1,  //方法参数错误，需要为数组格式
  TIME_OUT = 2,     //方法调用超时
  RESULT_NULL = 3   //结果返回null
} INVOKE_ERROR_TYPE;
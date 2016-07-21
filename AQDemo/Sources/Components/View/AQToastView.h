//
//  AQToastView.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface AQToastView : UIView

+ (void)presentToastWithInView:(UIView *)view text:(NSString *)text duration:(NSTimeInterval)duration;

@end

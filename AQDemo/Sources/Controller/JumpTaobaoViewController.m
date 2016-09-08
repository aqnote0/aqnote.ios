//
//  TaobaoViewController.m
//  AQDemo
//
//  Created by madding.lip on 8/24/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AQViewController.h"

@interface JumpTaobaoViewController : AQViewController

@property(nonatomic, retain) UIButton *jumpTaobaoHomeButton;
@property(nonatomic, retain) UIButton *jumpTaobaoHomeButton1;

@end

@implementation JumpTaobaoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"JumpTaobao";
  [self renderUI];
}

- (void)renderUI {
  CGFloat topHeight = [self getTopHeight] + 8;
  
  self.jumpTaobaoHomeButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.jumpTaobaoHomeButton setFrame:CGRectMake(140, topHeight, 128, 32)];
  [self.jumpTaobaoHomeButton setBackgroundColor:[UIColor blackColor]];
  [self.jumpTaobaoHomeButton setTitle:@"jump tb home" forState:UIControlStateNormal];
  [self.jumpTaobaoHomeButton addTarget:self
                      action:@selector(aciont_jump_taobao_home)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.jumpTaobaoHomeButton];
  
  self.jumpTaobaoHomeButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.jumpTaobaoHomeButton1 setFrame:CGRectMake(280, topHeight, 128, 32)];
  [self.jumpTaobaoHomeButton1 setBackgroundColor:[UIColor blackColor]];
  [self.jumpTaobaoHomeButton1 setTitle:@"jump tb home" forState:UIControlStateNormal];
  [self.jumpTaobaoHomeButton1 addTarget:self
                                action:@selector(aciont_jump_taobao_home2)
                      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.jumpTaobaoHomeButton1];
}

- (void)aciont_jump_taobao_home {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"taobao://m.taobao.com?"]];
}

- (void)aciont_jump_taobao_home2 {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"taobao://?"]];
}

@end

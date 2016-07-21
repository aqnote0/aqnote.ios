//
//  AQViewController.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import "AQViewController.h"

@implementation AQViewController

// 页面装载完成
- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSLog(@"[%@]viewDidLoad", NSStringFromClass([self class]));
  //  [MBProgressHUD showTextOnly:self.view message:@"viewDidLoad"];
}

// 页面显示之前， [Disappeared|Disappearing]->me->Appearing
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"[%@] viewWillAppear", NSStringFromClass([self class]));
  //  [MBProgressHUD showTextOnly:self.view message:@"viewWillAppear"];
}

// 页面显示之后， Appearing->me->Appeared
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSLog(@"[%@] viewDidAppear", NSStringFromClass([self class]));
  //  [MBProgressHUD showTextOnly:self.view message:@"viewDidAppear"];
}

// 页面消亡之前， [Appearing|Appeared]->me->Disappering
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  NSLog(@"[%@] viewWillDisappear", NSStringFromClass([self class]));
  //  [MBProgressHUD showTextOnly:self.view message:@"viewWillDisappear"];
}

// 页面消亡之后，Disappering->me->Disappeared
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  NSLog(@"[%@] viewDidDisappear", NSStringFromClass([self class]));
  //  [MBProgressHUD showTextOnly:self.view message:@"viewDidDisappear"];
}

// 内存不足
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"[%@] didReceiveMemoryWarning", NSStringFromClass([self class]));
  //  [MBProgressHUD showTextOnly:self.view message:@"didReceiveMemoryWarning"];
}

@end

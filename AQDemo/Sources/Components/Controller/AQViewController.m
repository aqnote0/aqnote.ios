//
//  AQViewController.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import "AQViewController.h"

#import "AQUtils.h"


@implementation AQViewController

// 页面装载完成
- (void)viewDidLoad {
  [super viewDidLoad];
  
//  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor whiteColor];
  self.title = @"";
//
//  self.navigationItem.hidesBackButton = YES;
//  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//  
//  UIButton *button = [[UIButton alloc ]init];
//  [button setFrame:CGRectMake(0, 0, 64, 24)];
//  [button setBackgroundColor:[UIColor clearColor]];
////  [button setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
////  [button setImage:nil forState:UIControlStateNormal];
////  [button setImage:nil forState:UIControlStateHighlighted];
////  [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
////  [button sizeToFit];
////  button.isAccessibilityElement = YES;
//  //  button.accessibilityLabel = @"back";
//  [button setTitle:@"back" forState:UIControlStateNormal];
//  [button addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
//  
//  
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  
  
  NSLog(@"[%@] viewDidLoad", NSStringFromClass([self class]));
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

- (void)onBack {
  if (self.push) {
    if ([self.navController respondsToSelector:@selector(popViewControllerAnimated:)]) {
      [self.navController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES]];
    }
  }
  else if ([self.navigationController.viewControllers count] == 1) {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
      // TODO
    }];
  }
  else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end

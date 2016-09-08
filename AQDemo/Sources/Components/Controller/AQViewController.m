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
  self.title = @"AQViewController";
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
  if ([self.navigationController.viewControllers count] == 1) {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (CGFloat)getTopHeight {
  CGFloat contentTopHeight = 0;
  CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
  contentTopHeight = statusBarFrame.origin.y + statusBarFrame.size.height;
  if(self.navigationController != nil) {
    CGRect navigationFrame = self.navigationController.navigationBar.frame;
    contentTopHeight = navigationFrame.origin.y + navigationFrame.size.height;
  }
  return contentTopHeight;
}

- (void)nextViewController:(UIViewController *)nextViewController {
  if(nextViewController == nil) return;
  if(self.navigationController != nil) {
    [self.navigationController pushViewController:nextViewController animated:NO];
  } else {
    [self presentViewController:nextViewController animated:YES completion:nil];
  }
}

- (BOOL)prefersStatusBarHidden {
  return NO;
}

@end

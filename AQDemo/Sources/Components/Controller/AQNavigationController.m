//
//  AQNavigationController.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQUtils.h"
#import "AQViewController.h"
#import "AQNavigationController.h"

@interface AQNavigationController ()

@end

@implementation AQNavigationController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"";
  // Do any additional setup after loading the view.
  NSMutableDictionary *attri = [NSMutableDictionary dictionary];
  [attri setObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
  [attri setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
  [self.navigationBar setTitleTextAttributes:attri];
  [self.navigationBar setShadowImage:[[UIImage alloc] init]];
  [self.navigationBar
      setBackgroundImage:
          [AQUtils createImageWithColor:[[UIColor whiteColor]
                                              colorWithAlphaComponent:1.0]]
           forBarMetrics:UIBarMetricsDefault];
  self.view.backgroundColor = [UIColor whiteColor];
}

- (BOOL)shouldAutorotate {
  return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return [self.topViewController preferredInterfaceOrientationForPresentation];
}
@end

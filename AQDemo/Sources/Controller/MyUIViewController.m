//
//  MyUIViewController.m
//  AQDemo
//
//  Created by madding.lip on 9/8/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQViewController.h"

@interface MyUIViewController : AQViewController

@property(nonatomic, assign) BOOL shouldHideStatusBar;
@property(nonatomic, retain) UIButton *hiddenStatusBarButton;

@end


@implementation MyUIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  CGFloat topHeight = [self getTopHeight] + 8;

  self.hiddenStatusBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.hiddenStatusBarButton setFrame:CGRectMake(20, topHeight, 128, 32)];
  [self.hiddenStatusBarButton setBackgroundColor:[UIColor blackColor]];
  [self.hiddenStatusBarButton setTitle:@"hidden statusbar" forState:UIControlStateNormal];
  [self.hiddenStatusBarButton addTarget:self
                                 action:@selector(action_change_status_bar)
                       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.hiddenStatusBarButton];
}

- (void)action_change_status_bar {
  self.shouldHideStatusBar = self.shouldHideStatusBar ? NO : YES;
  [self setNeedsStatusBarAppearanceUpdate];
  [self.hiddenStatusBarButton setTitle:@"display statusbar" forState:UIControlStateNormal];
}

- (void)action_change_navigation_bar {
}

- (BOOL)prefersStatusBarHidden {
  return self.shouldHideStatusBar;
}

@end
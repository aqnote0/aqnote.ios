//
//  AQUIViewController.m
//  AQDemo
//
//  Created by madding.lip on 8/24/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQViewController.h"
#import "AQUtils.h"

@interface AQPresentDismissViewController : AQViewController

@property(nonatomic, assign) NSNumber *setup;


@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIButton *presentButton;
@property(nonatomic, retain) UIButton *rootPresentButton;
@property(nonatomic, retain) UIButton *dismissButton;
@property(nonatomic, retain) UIButton *rootDismissButton;
@property(nonatomic, retain) UIButton *dismissToPresentButton;

@end


@implementation AQPresentDismissViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  CGFloat topHeight = [self getTopHeight] + 8;
  
  self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, topHeight, 128, 32)];
  self.label.backgroundColor = [UIColor whiteColor];
  self.label.text = [NSString stringWithFormat:@"%@", self.setup];
  [self.view addSubview:self.label];
  
  topHeight += 64;
  self.presentButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.presentButton setFrame:CGRectMake(20, topHeight, 128, 32)];
  [self.presentButton setBackgroundColor:[UIColor blackColor]];
  [self.presentButton setTitle:@"present" forState:UIControlStateNormal];
  [self.presentButton addTarget:self
                                 action:@selector(action_present_controller)
                       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.presentButton];
  
  topHeight += 64;
  self.rootPresentButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.rootPresentButton setFrame:CGRectMake(20, topHeight, 128, 32)];
  [self.rootPresentButton setBackgroundColor:[UIColor blackColor]];
  [self.rootPresentButton setTitle:@"root present" forState:UIControlStateNormal];
  [self.rootPresentButton addTarget:self
                         action:@selector(action_root_present_controller)
               forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.rootPresentButton];
  
  topHeight += 64;
  self.dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.dismissButton setFrame:CGRectMake(20, topHeight, 128, 32)];
  [self.dismissButton setBackgroundColor:[UIColor blackColor]];
  [self.dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
  [self.dismissButton addTarget:self
                             action:@selector(action_dismiss_controller)
                   forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.dismissButton];
  
  topHeight += 64;
  self.rootDismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.rootDismissButton setFrame:CGRectMake(20, topHeight, 128, 32)];
  [self.rootDismissButton setBackgroundColor:[UIColor blackColor]];
  [self.rootDismissButton setTitle:@"root dismiss" forState:UIControlStateNormal];
  [self.rootDismissButton addTarget:self
                         action:@selector(action_root_dismiss_controller)
               forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.rootDismissButton];
  
  topHeight += 64;
  self.dismissToPresentButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.dismissToPresentButton setFrame:CGRectMake(20, topHeight, 128, 32)];
  [self.dismissToPresentButton setBackgroundColor:[UIColor blackColor]];
  [self.dismissToPresentButton setTitle:@"dismiss toPresent" forState:UIControlStateNormal];
  [self.dismissToPresentButton addTarget:self
                         action:@selector(action_dismiss_topresent_controller)
               forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.dismissToPresentButton];
  
}

static int i = 0;
- (void)action_present_controller {
  AQPresentDismissViewController *toPresentViewController = [[AQPresentDismissViewController alloc] init];
  [toPresentViewController setSetup:[NSNumber numberWithInt:i++]];
  [self presentViewController:toPresentViewController animated:YES completion:nil];
}

- (void)action_root_present_controller {
  AQPresentDismissViewController *toPresentViewController = [[AQPresentDismissViewController alloc] init];
  [toPresentViewController setSetup:[NSNumber numberWithInt:i++]];
  UIWindow *window = [AQUtils getUIWindow];
  UIViewController *topViewController = [window rootViewController];
  [topViewController presentViewController:toPresentViewController animated:YES completion:nil];
}

- (void)action_dismiss_controller {
  // 把self关闭
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)action_root_dismiss_controller {
  AQPresentDismissViewController *toPresentViewController = [[AQPresentDismissViewController alloc] init];
  [toPresentViewController setSetup:[NSNumber numberWithInt:i++]];
  UIWindow *window = [AQUtils getUIWindow];
  UIViewController *topViewController = [window rootViewController];
  [topViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)action_dismiss_topresent_controller {
 // 把toPresent关闭
 //  [self dismissViewControllerAnimated:YES completion:nil];
 [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
}

// 页面显示之前， [Disappeared|Disappearing]->me->Appearing
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"[%@] viewWillAppear %@", NSStringFromClass([self class]), self.setup);
}

// 页面显示之后， Appearing->me->Appeared
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSLog(@"[%@] viewDidAppear %@", NSStringFromClass([self class]), self.setup);
}

// 页面消亡之前， [Appearing|Appeared]->me->Disappering
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  NSLog(@"[%@] viewWillDisappear %@", NSStringFromClass([self class]), self.setup);
}

// 页面消亡之后，Disappering->me->Disappeared
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  NSLog(@"[%@] viewDidDisappear %@", NSStringFromClass([self class]), self.setup);
}


@end

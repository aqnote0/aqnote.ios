//
//  LifecycleViewController.m
//  iosdev
//
//  Created by madding on 7/1/15.
//  Copyright (c) 2015 madding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "MBProgressHUD.h"

@interface DemoViewController
    : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *classNames;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation DemoViewController

- (id)init {
  if (self = [super init]) {
    self.title = @"UI使用例子";
    [self initTableInfo];
  }

  return self;
}

#pragma mark - Initialization
- (void)initTableInfo {
  self.titles = [NSArray
      arrayWithObjects:@[ @"多线程模拟",
                          @"内存管理",
                          @"联系人",
                          @"WebView" ],
                       nil];

  self.classNames = [NSArray arrayWithObjects:@[
    @"MutliThreadController",
    @"MemoryManageController",
    @"ContactsListViewController",
    @"WebViewController",
  ],
                                              nil];
}

- (void)initTableView {
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStylePlain];
  //  self.tableView.autoresizingMask =
  //      UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.titles[section] count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *mainCellIdentifier = @"MainCellIdentifier";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:mainCellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
  cell.detailTextLabel.text = self.classNames[indexPath.section][indexPath.row];

  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  NSString *className = self.classNames[indexPath.section][indexPath.row];

  UIViewController *subViewController =
      [[NSClassFromString(className) alloc] init];

  subViewController.title = self.titles[indexPath.section][indexPath.row];
  [self.navigationController
      pushViewController:(UIViewController *)subViewController
                animated:NO];
}

// 页面装载完成
- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"viewDidLoad");
  //  [MBProgressHUD showTextOnly:self.view message:@"viewDidLoad"];
  [self initTableView];
}

// 页面显示之前， [Disappeared|Disappearing]->me->Appearing
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"viewWillAppear");
  //  [MBProgressHUD showTextOnly:self.view message:@"viewWillAppear"];
}

// 页面显示之后， Appearing->me->Appeared
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSLog(@"viewDidAppear");
  //  [MBProgressHUD showTextOnly:self.view message:@"viewDidAppear"];
}

// 页面消亡之前， [Appearing|Appeared]->me->Disappering
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  NSLog(@"viewWillDisappear");
  //  [MBProgressHUD showTextOnly:self.view message:@"viewWillDisappear"];
}

// 页面消亡之后，Disappering->me->Disappeared
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  NSLog(@"viewDidDisappear");
  //  [MBProgressHUD showTextOnly:self.view message:@"viewDidDisappear"];
}

// 内存不足
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"didReceiveMemoryWarning");
  //  [MBProgressHUD showTextOnly:self.view message:@"didReceiveMemoryWarning"];
}

@end
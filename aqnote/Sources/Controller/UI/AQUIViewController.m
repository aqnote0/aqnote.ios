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
#import "AQViewController.h"

@interface AQUIViewController : AQViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *classNames;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation AQUIViewController

- (instancetype)init {
  self = [super init];
  if(self) {
     [self initTableInfo];
  }
  return self;
}

- (void) viewDidLoad {
  [super viewDidLoad];
  self.title = @"UI使用例子";
  [self initTableView];
}

#pragma mark - Initialization
- (void)initTableInfo {
  self.titles =[NSArray arrayWithObjects: @[ @"WebView",
                   @"WebView.cookie",
                   @"WebView.Hybrid",
                   @"ToastView",
                   @"TableView",
                   @"ButtonView",
                   @"PresentDismiss",
                   @"Jump"], nil];

  self.classNames = [NSArray arrayWithObjects:@[ @"StandrdWebViewController",
                       @"CookieViewController",
                       @"HybridWebViewController",
                       @"ToastViewController",
                       @"AQTableViewController",
                       @"AQButtonViewController",
                       @"AQPresentDismissViewController",
                       @"AQJumpViewController"], nil];
}

- (void)initTableView {
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStylePlain];
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.titles[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *mainCellIdentifier = @"MainCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  NSString *className = self.classNames[indexPath.section][indexPath.row];
  UIViewController *nextViewController = [[NSClassFromString(className) alloc] init];
  nextViewController.title = self.titles[indexPath.section][indexPath.row];
  [self nextViewController:nextViewController];
}

@end

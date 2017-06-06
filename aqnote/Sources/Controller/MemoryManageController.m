//
//  MutliThreadController.m
//  iosdev
//
//  Created by madding on 6/11/15.
//  Copyright (c) 2015 madding. All rights reserved.
//

#import "AQViewController.h"

#import <objc/message.h>
#import "MBProgressHUD.h"

@interface MemoryManageController : AQViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation MemoryManageController

- (id)init {
  self = [super init];
  if (self) {
    [self initTableInfo];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"线程分析代码";
  [self initTableView];
}

#pragma mark - Initialization
- (void)initTableInfo {
  self.titles = [NSArray arrayWithObjects:@"scene1", @"scene2", @"scene3", nil];
}

- (void)initTableView {
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStyleGrouped];
  self.tableView.autoresizingMask =
      UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *viewController = @"CrashController";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:viewController];

  NSInteger row = indexPath.row;

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:viewController];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  cell.textLabel.text = [self.titles objectAtIndex:row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  NSString *testCell = cell.textLabel.text;

  SEL sel = NSSelectorFromString(testCell);

  if ([self respondsToSelector:sel]) {
    ((void (*)(id, SEL, ...))objc_msgSend)(self, sel);
  } else {
    [MBProgressHUD showTextOnly:self.view message:@"没有找到测试接口"];
  }
}

/***************************************************************************************/
__weak NSString *string_weak_ = nil;

- (void)scene1 {
  [self fun01];
  [self fun1];
  [self fun2];
}

- (void)scene2 {
  [self fun02];
  [self fun1];
  [self fun2];
}

- (void)scene3 {
  [self fun03];
  [self fun1];
  [self fun2];
}

- (void)fun01 {
  NSString *string = [NSString stringWithFormat:@"data"];
  string_weak_ = string;
  NSLog(@"string: %@", string_weak_);
}

- (void)fun02 {
  @autoreleasepool {
    NSString *string = [NSString stringWithFormat:@"data"];
    string_weak_ = string;
  }
  NSLog(@"string: %@", string_weak_);
}

- (void)fun03 {
  NSString *string = nil;
  @autoreleasepool {
    string = [NSString stringWithFormat:@"data"];
    string_weak_ = string;
  }
  NSLog(@"string: %@", string_weak_);
}

- (void)fun1 {
  NSLog(@"string: %@", string_weak_);
  sleep(8);
}

- (void)fun2 {
  NSLog(@"string: %@", string_weak_);
  NSLog(@"\n");
}

@end
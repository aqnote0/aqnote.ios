//
//  ViewController.m
//  LBContacts
//
//  Created by fhkj on 15/6/15.
//  Copyright (c) 2015年 Bison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsListViewController
    : UIViewController<UITableViewDelegate, UITableViewDataSource> {
  NSMutableArray *Arr;
}

@end

@implementation ContactsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UITableView *tabview = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                               self.view.frame.size.height)
              style:UITableViewStylePlain];
  tabview.delegate = self;
  tabview.dataSource = self;
  [self.view addSubview:tabview];
}
#pragma mark - UITableView Delegate and Datasource functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return Arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 52.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"ContactCell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:cellIdentifier];
  }

  return cell;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

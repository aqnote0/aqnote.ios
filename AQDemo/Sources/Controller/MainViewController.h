//
//  ViewController.h
//  iosdev
//
//  Created by madding on 6/8/15.
//  Copyright (c) 2015 madding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController
    : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *classNames;
@property(nonatomic, strong) UITableView *tableView;

@end

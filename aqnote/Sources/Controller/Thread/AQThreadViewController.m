//
//  AQThreadViewController.m
//  aqnote
//
//  Created by Peng Li on 6/29/18.
//  Copyright © 2018 Peng Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "MBProgressHUD.h"
#import "AQViewController.h"

@interface AQThreadViewController : AQViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *classNames;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation AQThreadViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        [self initTableInfo];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.title = @"Thread";
    [self initTableView];
}

#pragma mark - Initialization
- (void)initTableInfo {
    self.titles = [NSArray arrayWithObjects:@[@"模拟多线程"], nil];
    
    self.classNames = [NSArray arrayWithObjects:@[@"MutliThreadController"], nil];
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

//
//  ViewController.m
//  LBContacts
//
//  Created by fhkj on 15/6/15.
//  Copyright (c) 2015年 Bison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@interface AddressListViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) bool contactStoreFlag;
@property(nonatomic, strong) CNContactStore *contactStore;

@end

@implementation AddressListViewController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
  [super viewDidLoad];
    
    bool result = [self requestAuthorization];
    if(!result) {
        return;
    }
    
  UITableView *tabview = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
              style:UITableViewStylePlain];
  tabview.delegate = self;
  tabview.dataSource = self;
  [self.view addSubview:tabview];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"ContactCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:cellIdentifier];
  }

  return cell;
}


#pragma mark - Permissions
- (bool)requestAuthorization {
    // 判断是否授权
    __block bool result = false;
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
       self.contactStore = [[CNContactStore alloc] init];
        [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
                result = true;
            } else {
                NSLog(@"授权失败, error=%@", error);
            }
        }];
    }
    return result;
}

@end

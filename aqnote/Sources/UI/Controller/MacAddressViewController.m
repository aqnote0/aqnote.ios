//
//  ViewController.m
//  GetIphoneMacAddress
//
//  Created by Jdb on 16/3/28.
//  Copyright © 2016年 uimbank. All rights reserved.
//

#include <sys/sysctl.h>
#include <sys/utsname.h>
#include <ifaddrs.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/sysctl.h>
#include <sys/param.h>
#include <sys/file.h>
#include <net/if.h>
#include <netinet/in.h>
#include <net/if_dl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include "if_arp.h"
#include "if_dl.h"
#include "route.h"
#include "if_ether.h"
#include <net/ethernet.h>
#include <err.h>
#include <errno.h>
#include <paths.h>

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#include "NICInfo.h"
#include "NICInfoSummary.h"
#import "AQViewController.h"
#import "AQUtils.h"


//#define SIOCGIFADDR 0x8915    /* get PA address */
//#define SIOCSIFADDR 0x8916    /* set PA address */
#define SIOCGIFHWADDR 0x8927  /* Get hardware address */
#define  ATF_PROXY  0x20
#define IFT_ETHER 0x6

static NSString *cellId = @"Cell";

@interface MacAddressViewController : AQViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UILabel *wifiSsiddLabel;
@property (strong, nonatomic) UILabel *wifiBssidLabel;
@property (strong, nonatomic) UITableView *macAddressTableView;
@property (nonatomic,strong)NSMutableArray *rqlistarry;

@end

@implementation MacAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initData];
  
    [self renderUI:[self fetchSSIDInfo]];
    
    [self ip2mac];
}

- (void)initData {
  self.rqlistarry = [NSMutableArray array];
}

- (void)renderUI:(id)info {
  
  CGFloat topHeight = [self getTopHeight] + 8;
  CGFloat betweenHeight = 64;
  UIFont *font = [UIFont fontWithName:@"Noto Mono" size:12.0];
  
  self.wifiSsiddLabel = [[UILabel alloc] init];
  
  //NSLog(@"%@WIFI名字：%@",info,[info objectForKey:@"SSID"]);
  self.wifiSsiddLabel.text = [NSString stringWithFormat:@"当前热点：%@",[info objectForKey:@"SSID"]];
  //  [UIFont boldSystemFontOfSize:12.0];
  self.wifiSsiddLabel.font = font;
  self.wifiSsiddLabel.frame = CGRectMake(8, topHeight, 208, 64);
  self.wifiSsiddLabel.backgroundColor = [UIColor blackColor];
  self.wifiSsiddLabel.text = @"No Info";
  self.wifiSsiddLabel.textColor = [UIColor whiteColor];
  self.wifiSsiddLabel.textAlignment = NSTextAlignmentLeft;
  [self.view addSubview:self.wifiSsiddLabel];
  
  topHeight = topHeight + betweenHeight + 8;
  self.wifiBssidLabel = [[UILabel alloc] init];
  self.wifiBssidLabel.text = [NSString stringWithFormat:@"路由地址：%@",[self standardFormateMAC:[info objectForKey:@"BSSID"]]];
  self.wifiBssidLabel.font = font;
  self.wifiBssidLabel.frame = CGRectMake(8, topHeight, 208, 64);
  self.wifiBssidLabel.backgroundColor = [UIColor blackColor];
  self.wifiBssidLabel.text = @"No Info";
  self.wifiBssidLabel.textColor = [UIColor whiteColor];
  self.wifiBssidLabel.textAlignment = NSTextAlignmentLeft;
  [self.view addSubview:self.wifiBssidLabel];
  
  topHeight = topHeight + betweenHeight + 8;
  self.macAddressTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.macAddressTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.macAddressTableView.delegate = self;
  self.macAddressTableView.dataSource = self;
  self.macAddressTableView.tag = 1;
  [self.macAddressTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
  [self.view addSubview:self.macAddressTableView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //告诉TableView有几个分区
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //告诉Tableview当前分区有几行
    if ([self.rqlistarry count] == 0)
        return 0;
    //NSLog(@"namesection count[%i]",[self.shopTitle count]);
    return [self.rqlistarry count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSLog(@"section[%lu]",(unsigned long)section);
    
    NSUInteger row = [indexPath row];
  
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (tableViewCell != nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    UIView *cellview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    icon.image = [AQUtils createImageWithColor:UIColorFromRGB(0X00FF00)];
    
    UILabel *macAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 3, self.view.frame.size.width-55, 19)];
    macAddressLabel.text = [[self.rqlistarry objectAtIndex:row] substringToIndex:17];
    macAddressLabel.font = [UIFont systemFontOfSize:16.0f];
    
    UILabel *ipAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 25, self.view.frame.size.width-55, 19)];
    ipAddressLabel.textColor = [UIColor grayColor];
    ipAddressLabel.text = [[self.rqlistarry objectAtIndex:row] substringFromIndex:17];
    ipAddressLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    [cellview.self addSubview:icon];
    [cellview.self addSubview:macAddressLabel];
    [cellview.self addSubview:ipAddressLabel];
    [tableViewCell.self addSubview:cellview];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return tableViewCell;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
//头部高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
//尾部部高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

//头部view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 40/2-10, self.view.frame.size.width, 20)];
    headerLab.text = [NSString stringWithFormat:@"路由器所链接的设备数为：%lu",(unsigned long)[self.rqlistarry count]];
    headerLab.textColor = [UIColor grayColor];
    headerLab.font = [UIFont fontWithName:@"Arial" size:17];
    [headerView addSubview:headerLab];
    return headerView;
}


-(NSString*) ip2mac {
    int flags = 0,  found_entry = 0;
    NSString *mAddr = nil;
    u_long addr = inet_addr([[self getIPAddress] UTF8String]);
    //NSLog(@"---------%s",[[self getIPAddress] UTF8String]);
    int mib[6];
    size_t needed;
    char *host, *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    extern int h_errno;
    struct hostent *hp;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
    if ((buf = malloc(needed)) == NULL)
        err(1, "malloc");
    if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
        err(1, "actual retrieval of routing table");
    
    lim = buf + needed;
    //NSLog(@"********---%s",lim);
    for (next = buf; next < lim; next += rtm->rtm_msglen) {
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
        if (addr) {
            if (addr != sin->sin_addr.s_addr)
                //NSLog(@"%lu,%u",addr,sin->sin_addr.s_addr);
                //continue;
                found_entry = 1;
        }
        if (flags == 0)
            hp = gethostbyaddr((caddr_t)&(sin->sin_addr),
                               sizeof sin->sin_addr, AF_INET);
        else
            hp = 0;
        if (hp)
            host = hp->h_name;
        else {
            host = "?";
            if (h_errno == TRY_AGAIN)
                flags = 1;
        }
        
        if (sdl->sdl_alen) {
            u_char  *cp = (u_char*)LLADDR(sdl);
            mAddr = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
            [self.rqlistarry addObject:[NSString stringWithFormat:@"%@%s",mAddr,inet_ntoa(sin->sin_addr)]];
            [self.macAddressTableView reloadData];
        }else{
            mAddr = nil;
        }
    }
    
    if (found_entry == 0) {
        free(buf);
        return nil;
    } else {
        free(buf);
        return mAddr;
    }
}

// Get IP Address
-(NSString *)getIPAddress {
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

#pragma mark -获取当前已经链接的wifi信息
- (id)fetchSSIDInfo {
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    //NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        //NSLog(@"%@ => %@ ssidname:[%@]", ifnam, info,[info objectForKey:@"SSID"]);
        if (info && [info count]) { break; }
    }
    return info;
}

#pragma mark ----wifi mac少头0预防
- (NSString *)standardFormateMAC:(NSString *)macAddress {
    NSArray * macAddressArray = [macAddress componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":-"]];
    NSMutableArray * macAddressMArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString * str in macAddressArray) {
        if (1 == str.length) {
            NSString * tmpStr = [NSString stringWithFormat:@"0%@", str];
            [macAddressMArray addObject:tmpStr];
        } else {
            [macAddressMArray addObject:str];
        }
    }
    
    NSString * formateMAC = [macAddressMArray componentsJoinedByString:@":"];
    return [formateMAC uppercaseString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

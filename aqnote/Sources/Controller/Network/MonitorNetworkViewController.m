
#import "AQViewController.h"

#import <AQFoundation/Reachability.h>


@interface MonitorNetworkViewController : AQViewController

@property(retain, nonatomic) UILabel* taobaoLabel;
@property(retain, nonatomic) UILabel* localWifiLabel;
@property(retain, nonatomic) UILabel* connectionLabel;

@property(strong) Reachability* aqnoteReach;
@property(strong) Reachability* localWiFiReach;
@property(strong) Reachability* connectionReach;

@end


@implementation MonitorNetworkViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"网络状态监控";
  [self renderUI];
  [self monitorNetwork];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)renderUI {
  UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];

  self.taobaoLabel = [[UILabel alloc] init];
  self.taobaoLabel.font = font;
  self.taobaoLabel.frame = CGRectMake(20, 80, 240, 60);
  self.taobaoLabel.backgroundColor = [UIColor blackColor];
  self.taobaoLabel.text = @"Not Info";
  self.taobaoLabel.textColor = [UIColor whiteColor];
  self.taobaoLabel.textAlignment = NSTextAlignmentLeft;
  [self.view addSubview:self.taobaoLabel];

  self.localWifiLabel = [[UILabel alloc] init];
  self.localWifiLabel.font = font;
  self.localWifiLabel.frame = CGRectMake(20, 220, 240, 60);
  self.localWifiLabel.backgroundColor = [UIColor blackColor];
  self.localWifiLabel.text = @"Not Info";
  self.localWifiLabel.textColor = [UIColor whiteColor];
  self.localWifiLabel.textAlignment = NSTextAlignmentLeft;
  [self.view addSubview:self.localWifiLabel];

  self.connectionLabel = [[UILabel alloc] init];
  self.connectionLabel.font = font;
  self.connectionLabel.frame = CGRectMake(20, 360, 240, 60);
  self.connectionLabel.backgroundColor = [UIColor blackColor];
  self.connectionLabel.text = @"Not Info";
  self.connectionLabel.textColor = [UIColor whiteColor];
  self.connectionLabel.textAlignment = NSTextAlignmentLeft;
  [self.view addSubview:self.connectionLabel];
}

- (void)monitorNetwork {
  __weak __block typeof(self) weakself = self;

  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////
  //
  // create a Reachability object for m.taobao.com

  self.aqnoteReach = [Reachability reachabilityWithHostname:@"aqnote.com"];

  self.aqnoteReach.reachableBlock = ^(Reachability* reachability) {
    NSString* temp =
        [NSString stringWithFormat:@"Taobao Reachable(%@)",
                                   reachability.currentReachabilityFlags];
    NSLog(@"%@", temp);

    // to update UI components from a block callback
    // you need to dipatch this to the main thread
    // this uses NSOperationQueue mainQueue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      weakself.taobaoLabel.text = temp;
      weakself.taobaoLabel.textColor = [UIColor blackColor];
    }];
  };

  self.aqnoteReach.unreachableBlock = ^(Reachability* reachability) {
    NSString* temp =
        [NSString stringWithFormat:@"Taobao Unreachable(%@)",
                                   reachability.currentReachabilityFlags];
    NSLog(@"%@", temp);

    // to update UI components from a block callback
    // you need to dipatch this to the main thread
    // this one uses dispatch_async they do the same thing (as above)
    dispatch_async(dispatch_get_main_queue(), ^{
      weakself.taobaoLabel.text = temp;
      weakself.taobaoLabel.textColor = [UIColor redColor];
    });
  };

  [self.aqnoteReach startNotifier];

  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////
  //
  // create a reachability for the local WiFi

  self.localWiFiReach = [Reachability reachabilityForLocalWiFi];

  // we ONLY want to be reachable on WIFI - cellular is NOT an acceptable
  // connectivity
  self.localWiFiReach.reachableOnWWAN = NO;

  self.localWiFiReach.reachableBlock = ^(Reachability* reachability) {
    NSString* temp =
        [NSString stringWithFormat:@"LocalWIFI Reachable(%@)",
                                   reachability.currentReachabilityFlags];
    NSLog(@"%@", temp);

    dispatch_async(dispatch_get_main_queue(), ^{
      weakself.localWifiLabel.text = temp;
      weakself.localWifiLabel.textColor = [UIColor blackColor];
    });
  };

  self.localWiFiReach.unreachableBlock = ^(Reachability* reachability) {
    NSString* temp =
        [NSString stringWithFormat:@"LocalWIFI Unreachable(%@)",
                                   reachability.currentReachabilityFlags];

    NSLog(@"%@", temp);
    dispatch_async(dispatch_get_main_queue(), ^{
      weakself.localWifiLabel.text = temp;
      weakself.localWifiLabel.textColor = [UIColor redColor];
    });
  };

  [self.localWiFiReach startNotifier];

  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////
  //
  // create a Reachability object for the internet

  self.connectionReach = [Reachability reachabilityForInternetConnection];

  self.connectionReach.reachableBlock = ^(Reachability* reachability) {
    NSString* temp =
        [NSString stringWithFormat:@"Connection Reachable(%@)",
                                   reachability.currentReachabilityFlags];
    NSLog(@"%@", temp);

    dispatch_async(dispatch_get_main_queue(), ^{
      weakself.connectionLabel.text = temp;
      weakself.connectionLabel.textColor = [UIColor blackColor];
    });
  };

  self.connectionReach.unreachableBlock = ^(Reachability* reachability) {
    NSString* temp =
        [NSString stringWithFormat:@"Connection Unreachable(%@)",
                                   reachability.currentReachabilityFlags];

    NSLog(@"%@", temp);
    dispatch_async(dispatch_get_main_queue(), ^{
      weakself.connectionLabel.text = temp;
      weakself.connectionLabel.textColor = [UIColor redColor];
    });
  };

  [self.connectionReach startNotifier];
}

@end

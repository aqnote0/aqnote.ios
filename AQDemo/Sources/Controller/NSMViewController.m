
#import <AQFoundation/Reachability.h>
#import <UIKit/UIKit.h>

@interface NSMViewController : UIViewController

@property(retain, nonatomic) UILabel* taobaoLabel;
@property(retain, nonatomic) UILabel* localWifiLabel;
@property(retain, nonatomic) UILabel* connectionLabel;

@end

@interface NSMViewController ()

@property(strong) Reachability* taobaoReach;
@property(strong) Reachability* localWiFiReach;
@property(strong) Reachability* connectionReach;

@end

@implementation NSMViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self renderUI];
  [self monitorNetwork];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)renderUI {
  UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];

  self.taobaoLabel = [[UILabel alloc] init];
  [self.view addSubview:self.taobaoLabel];
  self.taobaoLabel.font = font;
  self.taobaoLabel.frame = CGRectMake(20, 80, 240, 60);
  self.taobaoLabel.backgroundColor = [UIColor lightGrayColor];
  self.taobaoLabel.textAlignment = NSTextAlignmentLeft;
  self.taobaoLabel.text = @"Not Info";

  self.localWifiLabel = [[UILabel alloc] init];
  [self.view addSubview:self.localWifiLabel];
  self.localWifiLabel.font = font;
  self.localWifiLabel.frame = CGRectMake(20, 220, 240, 60);
  self.localWifiLabel.backgroundColor = [UIColor lightGrayColor];
  self.localWifiLabel.textAlignment = NSTextAlignmentLeft;
  self.localWifiLabel.text = @"Not Info";

  self.connectionLabel = [[UILabel alloc] init];
  [self.view addSubview:self.connectionLabel];
  self.connectionLabel.font = font;
  self.connectionLabel.frame = CGRectMake(20, 360, 240, 60);
  self.connectionLabel.backgroundColor = [UIColor lightGrayColor];
  self.connectionLabel.textAlignment = NSTextAlignmentLeft;
  self.connectionLabel.text = @"Not Info";
}

- (void)monitorNetwork {
  __weak __block typeof(self) weakself = self;

  //////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////
  //
  // create a Reachability object for m.taobao.com

  self.taobaoReach = [Reachability reachabilityWithHostname:@"m.taobao.com"];

  self.taobaoReach.reachableBlock = ^(Reachability* reachability) {
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

  self.taobaoReach.unreachableBlock = ^(Reachability* reachability) {
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

  [self.taobaoReach startNotifier];

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

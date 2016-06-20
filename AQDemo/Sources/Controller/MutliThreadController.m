//
//  ViewController.m
//  mutlithread
//
//  Created by madding on 3/23/15.
//  Copyright (c) 2015 madding. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MutliThreadController : UIViewController

@property(retain, nonatomic) UITextView *display;
@property(retain, nonatomic) UIButton *concurrencyBtn;
@property(retain, nonatomic) UIButton *asyncBtn;
@property(retain, nonatomic) UIButton *syncBtn;
@property(retain, nonatomic) UIActivityIndicatorView *spinner;

- (IBAction)doConcurrency:(id)sender;

- (IBAction)doAsync:(id)sender;

- (IBAction)doSync:(id)sender;

@end

@implementation MutliThreadController

@synthesize display, spinner, concurrencyBtn, asyncBtn, syncBtn;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self renderButtons];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"load view...");
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)renderButtons {
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];

  display = [UITextView new];
  [self.view addSubview:display];
  display.font = font;
  display.frame = CGRectMake(20, 80, 240, 120);
  display.backgroundColor = [UIColor lightGrayColor];
  display.textAlignment = NSTextAlignmentLeft;
  display.text = @"内容";
  display.editable = NO;

  concurrencyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [concurrencyBtn setTitle:@"并行" forState:UIControlStateNormal];
  [concurrencyBtn addTarget:self
                     action:@selector(doConcurrency:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:concurrencyBtn];
  concurrencyBtn.frame = CGRectMake(20, 268, 45, 45);
  concurrencyBtn.titleLabel.font = font;
  concurrencyBtn.backgroundColor = [UIColor orangeColor];

  asyncBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [asyncBtn setTitle:@"异步" forState:UIControlStateNormal];
  [asyncBtn addTarget:self
                action:@selector(doAsync:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:asyncBtn];
  asyncBtn.frame = CGRectMake(120, 268, 45, 45);
  asyncBtn.titleLabel.font = font;
  asyncBtn.backgroundColor = [UIColor orangeColor];

  syncBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [syncBtn setTitle:@"同步" forState:UIControlStateNormal];
  [syncBtn addTarget:self
                action:@selector(doAsync:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:syncBtn];
  syncBtn.frame = CGRectMake(220, 268, 45, 45);
  syncBtn.titleLabel.font = font;
  syncBtn.backgroundColor = [UIColor orangeColor];
}

- (NSString *)fetchSomethingFromServer {
  [NSThread sleepForTimeInterval:1];
  return @"server data";
}

- (NSString *)processData:(NSString *)data {
  [NSThread sleepForTimeInterval:2];
  return [data uppercaseString];
}

- (NSString *)calculateFirstResult:(NSString *)data {
  [NSThread sleepForTimeInterval:3];
  return @"frist result";
}

- (NSString *)calculateSecondResult:(NSString *)data {
  [NSThread sleepForTimeInterval:4];
  return @"second result";
}

// 并发程序块
- (IBAction)doConcurrency:(id)sender {
  concurrencyBtn.enabled = NO;
  concurrencyBtn.alpha = 0.5;
  [spinner startAnimating];
  NSDate *startTime = [NSDate date];
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString *fetchedData = [self fetchSomethingFromServer];
    NSString *processData = [self processData:fetchedData];

    dispatch_group_t group = dispatch_group_create();
    __block NSString *firstResult;
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
      NSLog(@"calculateFirstResult...");
      firstResult = [self calculateFirstResult:processData];
    });

    __block NSString *secondResult;
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
      NSLog(@"calculateSecondResult...");
      secondResult = [self calculateSecondResult:processData];
    });

    // dispatch_group_notify指定一个额外的程序块，该程序块将在组中的所有程序块运行完成时执行
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
      NSString *result = [NSString
          stringWithFormat:@"cost in %f seconds",
                           [[NSDate date] timeIntervalSinceDate:startTime]];
      // dispatch_get_main_queue主线程
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"finish.");
        concurrencyBtn.enabled = YES;
        concurrencyBtn.alpha = 1.0;
        [spinner stopAnimating];
        display.text = result;
      });

    });
  });
}

// 异步执行
- (IBAction)doAsync:(id)sender {
  asyncBtn.enabled = NO;
  asyncBtn.alpha = 0.5;
  [spinner startAnimating];
  NSDate *startTime = [NSDate date];
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString *fetchedData = [self fetchSomethingFromServer];
    NSString *processData = [self processData:fetchedData];
    [self calculateFirstResult:processData];
    [self calculateSecondResult:processData];
    NSString *result = [NSString
        stringWithFormat:@"cost in %f seconds",
                         [[NSDate date] timeIntervalSinceDate:startTime]];
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"finish.");
      asyncBtn.enabled = YES;
      asyncBtn.alpha = 1.0;
      [spinner stopAnimating];
      display.text = result;
    });
  });
}

//同步执行
- (IBAction)doSync:(id)sender {
  NSDate *startTime = [NSDate date];
  NSString *fetchedData = [self fetchSomethingFromServer];
  NSString *processData = [self processData:fetchedData];
  [self calculateFirstResult:processData];
  [self calculateSecondResult:processData];
  NSString *result = [NSString
      stringWithFormat:@"cost in %f seconds",
                       [[NSDate date] timeIntervalSinceDate:startTime]];
  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"finish.");
    display.text = result;
  });
}

@end

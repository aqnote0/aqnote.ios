//
//  ViewController.m
//  mutlithread
//
//  Created by madding on 3/23/15.
//  Copyright (c) 2015 madding. All rights reserved.
//

#import "AQViewController.h"

@interface MutliThreadController : AQViewController

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

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"load view...");
  self.title = @"多线程模拟";
  [self renderButtons];
}

- (void)renderButtons {
  
  CGFloat topHeight = [self getTopHeight] + 8;
  CGFloat betweenHeight = 64;
  
  
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];

  self.display = [UITextView new];
  [self.view addSubview:self.display];
  self.display.font = font;
  self.display.frame = CGRectMake(20, topHeight, 240, 120);
  self.display.backgroundColor = [UIColor lightGrayColor];
  self.display.textAlignment = NSTextAlignmentLeft;
  self.display.text = @"内容";
  self.display.editable = NO;

  topHeight = topHeight + betweenHeight*2;
  self.concurrencyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.concurrencyBtn setTitle:@"并行" forState:UIControlStateNormal];
  [self.concurrencyBtn addTarget:self
                     action:@selector(doConcurrency:)
           forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.concurrencyBtn];
  self.concurrencyBtn.frame = CGRectMake(20, topHeight, 32, 32);
  self.concurrencyBtn.titleLabel.font = font;
  self.concurrencyBtn.backgroundColor = [UIColor orangeColor];

  self.asyncBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.asyncBtn setTitle:@"异步" forState:UIControlStateNormal];
  [self.asyncBtn addTarget:self
                action:@selector(doAsync:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.asyncBtn];
  self.asyncBtn.frame = CGRectMake(120, topHeight, 32, 32);
  self.asyncBtn.titleLabel.font = font;
  self.asyncBtn.backgroundColor = [UIColor orangeColor];

  self.syncBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.syncBtn setTitle:@"同步" forState:UIControlStateNormal];
  [self.syncBtn addTarget:self
                action:@selector(doAsync:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.syncBtn];
  self.syncBtn.frame = CGRectMake(220, topHeight, 32, 32);
  self.syncBtn.titleLabel.font = font;
  self.syncBtn.backgroundColor = [UIColor orangeColor];
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
        self.concurrencyBtn.enabled = YES;
        self.concurrencyBtn.alpha = 1.0;
        [self.spinner stopAnimating];
        self.display.text = result;
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
      self.asyncBtn.enabled = YES;
      self.asyncBtn.alpha = 1.0;
      [self.spinner stopAnimating];
      self.display.text = result;
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
    self.display.text = result;
  });
}

@end

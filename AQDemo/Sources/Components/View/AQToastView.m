//
//  AQToastView.m
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//
#import "AQToastView.h"

#import <QuartzCore/QuartzCore.h>

static const BOOL CSToastDisplayShadow = YES;

@interface AQToastView ()

@property(nonatomic, strong) NSString *toastText;
@property(nonatomic, weak) UILabel *textLabel;

@end

@implementation AQToastView

+ (void)presentToastWithInView:(UIView *)view
                          text:(NSString *)text
                      duration:(NSTimeInterval)duration {
  AQToastView *toast = [[AQToastView alloc] init];
  toast.toastText = text;
  [toast sizeToFit];

  [toast showInView:view duration:duration];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                             UIViewAutoresizingFlexibleRightMargin |
                             UIViewAutoresizingFlexibleTopMargin |
                             UIViewAutoresizingFlexibleBottomMargin);
    self.layer.cornerRadius = 8.0f;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.f];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.alpha = 1.0;
    [self addSubview:label];

    self.textLabel = label;
  }
  return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
  self.textLabel.text = self.toastText;

  // size the message label according to the length of the text
  CGSize maxSizeMessage =
      CGSizeMake(200, [UIScreen mainScreen].bounds.size.height / 2);
  CGSize expectedSizeMessage =
      [self sizeForString:self.toastText
                       font:self.textLabel.font
          constrainedToSize:maxSizeMessage
              lineBreakMode:self.textLabel.lineBreakMode];
  self.textLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width,
                                    expectedSizeMessage.height);

  CGSize ret = CGSizeMake(228, expectedSizeMessage.height + 10 + 30);
  self.textLabel.center = CGPointMake(ret.width / 2, ret.height / 2);

  return ret;
}

- (CGSize)sizeForString:(NSString *)string
                   font:(UIFont *)font
      constrainedToSize:(CGSize)constrainedSize
          lineBreakMode:(NSLineBreakMode)lineBreakMode {
  if ([string respondsToSelector:@selector(boundingRectWithSize:
                                                        options:
                                                     attributes:
                                                        context:)]) {
    NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{
      NSFontAttributeName : font,
      NSParagraphStyleAttributeName : paragraphStyle
    };
    CGRect boundingRect =
        [string boundingRectWithSize:constrainedSize
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:attributes
                             context:nil];
    return CGSizeMake(206, ceilf(boundingRect.size.height));
  }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  return [string sizeWithFont:font
            constrainedToSize:constrainedSize
                lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration {
  self.center =
      CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
  [view addSubview:self];
  self.alpha = 0.9;
  [UIView animateWithDuration:duration
      delay:0.0
      options:(UIViewAnimationOptionCurveEaseOut)
      animations:^{
        self.alpha = 1.0;
      }
      completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self dismiss];
        });
      }];
}

- (void)dismiss {
  [UIView animateWithDuration:0.1f
      delay:0.0
      options:(UIViewAnimationOptionCurveEaseIn)
      animations:^{
        self.alpha = 0.0;
      }
      completion:^(BOOL finished) {
        [self removeFromSuperview];
      }];
}

@end
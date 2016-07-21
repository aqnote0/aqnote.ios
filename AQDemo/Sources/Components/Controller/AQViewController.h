//
//  AQViewController.h
//  AQDemo
//
//  Created by madding.lip on 7/21/16.
//  Copyright © 2016 Peng Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AQViewController : UIViewController

/** 是否push */
@property (nonatomic, assign) BOOL push;

/** 当时通过push进来的时候，即push为真的时候，此属性会有值 */
@property (nonatomic, weak) UINavigationController *navController;

- (void)onBack;

@end

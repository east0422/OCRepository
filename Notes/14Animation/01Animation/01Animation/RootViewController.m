//
//  RootViewController.m
//  01Animation
//
//  Created by dfang on 2019-6-5.
//  Copyright © 2019年 east. All rights reserved.
//

#import "RootViewController.h"
#import "left-right/LeftViewController.h"
#import "left-right/RightViewController.h"
#import "animations/BasicAnimationVC.h"
#import <SWRevealViewController/SWRevealViewController.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    BasicAnimationVC *centerVC = [[BasicAnimationVC alloc] init];
    RightViewController *rightVC = [[RightViewController alloc] init];
    SWRevealViewController *revealVC = [[SWRevealViewController alloc] initWithRearViewController:leftVC frontViewController:centerVC];
    revealVC.rightViewController = rightVC;
    [revealVC setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [self presentViewController:revealVC animated:YES completion:nil];
    });
}

@end

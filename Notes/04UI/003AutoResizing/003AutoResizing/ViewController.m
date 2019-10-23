//
//  ViewController.m
//  003AutoResizing
//
//  Created by dfang on 2019-10-22.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 定义blueView距离右侧20px,顶部20px,宽高固定
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    CGFloat width = 250, height = 100;
    CGFloat paddingRight = 20, paddingTop = 20;
    blueView.frame = CGRectMake(self.view.frame.size.width - width - paddingRight, paddingTop, width, height);
    // autoresizesSubviews默认值为YES
    self.view.autoresizesSubviews = YES;
    blueView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:blueView];
}


@end

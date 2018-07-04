//
//  SingletonViewController.m
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import "SingletonViewController.h"
#import "TransferParamSingleton.h"

@interface SingletonViewController ()

@end

@implementation SingletonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGSize screenSize = self.view.frame.size;
    
    // 添加返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 60)];
    backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToMainVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    // 添加label显示ViewController传递过来的值
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, screenSize.width, 200)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [TransferParamSingleton defaultSingleton].param;
    label.textColor = UIColor.redColor;
    
    [self.view addSubview:label];
}

- (void)backToMainVC {
    [TransferParamSingleton defaultSingleton].param = @"使用单例改变后回传的参数";
    if (self.callbackBlock) {
        self.callbackBlock();
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

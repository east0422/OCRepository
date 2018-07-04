//
//  DelegateViewController.m
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import "DelegateViewController.h"

@interface DelegateViewController ()

@end

@implementation DelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    
    // 添加返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 60)];
    backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [backBtn setTitle:@"回传参数Delegate" forState:UIControlStateNormal];
    [backBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToMainVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backToMainVC {
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegateViewController:goBackWithParam:)]) {
        [self.delegate delegateViewController:self goBackWithParam:@"Delegate回传参数"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

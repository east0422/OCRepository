//
//  ViewController.m
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import "ViewController.h"
#import "PropertyViewController.h"
#import "BlockViewController.h"
#import "DelegateViewController.h"
#import "NotificationViewController.h"
#import "TransferParamSingleton.h"
#import "SingletonViewController.h"

@interface ViewController () <DelegateViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)showAlertWithMsg:(NSString *)msg {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle: @"alert显示结果" message: msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    // 使用dispatch_async为了解决弹出框不出现或出现时有警告⚠️，主要目的是为了使得对象的视图已加入到窗口中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertVC animated:YES completion:nil];
        });
    });
}

- (IBAction)properClicked:(UIButton *)sender {
    PropertyViewController *proVC = [[PropertyViewController alloc] init];
    proVC.name = @"来自主界面的属性";
    [self presentViewController:proVC animated:YES completion:nil];
}

- (IBAction)initProClicked:(UIButton *)sender {
    PropertyViewController *proVC = [[PropertyViewController alloc] initPropertyVCWithName:@"来自主界面的init"];
    [self presentViewController:proVC animated:YES completion:nil];
}

- (IBAction)blockClicked:(UIButton *)sender {
    BlockViewController *blockVC = [[BlockViewController alloc] init];
    [blockVC getParamWithBlock:^(NSString *param) {
        [self showAlertWithMsg:param];
    }];
    [self presentViewController:blockVC animated:YES completion:nil];
}

- (IBAction)delegateClicked:(UIButton *)sender {
    DelegateViewController *delegateVC = [[DelegateViewController alloc] init];
    delegateVC.delegate = self;
    [self presentViewController:delegateVC animated:YES completion:nil];
}

- (void)delegateViewController:(DelegateViewController *)delegateVC goBackWithParam:(NSString *)param {
    [self showAlertWithMsg:param];
}

- (IBAction)notifyClicked:(UIButton *)sender {
    NotificationViewController *notifyVC = [[NotificationViewController alloc] init];
    // name必须和postnotification中的name保持一致
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToNotification:) name:@"notifyparam" object:nil];
    [self presentViewController:notifyVC animated:YES completion:nil];
}

- (void)respondToNotification:(NSNotification *)notify {
    [self showAlertWithMsg:[notify.userInfo valueForKey:@"param"]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)singletonClicked:(UIButton *)sender {
    TransferParamSingleton *singleton = [TransferParamSingleton defaultSingleton];
    singleton.param = @"singleton init";
    SingletonViewController *singletonVC = [[SingletonViewController alloc] init];
    singletonVC.callbackBlock = ^{
        [self showAlertWithMsg:singleton.param];
    };
    [self presentViewController:singletonVC animated:YES completion:nil];
}

- (IBAction)othersClicked:(UIButton *)sender {
    [self showAlertWithMsg:@"NSUserDefaults, sharedApplication等"];
}


@end

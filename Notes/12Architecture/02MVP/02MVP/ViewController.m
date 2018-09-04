//
//  ViewController.m
//  02MVP
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "ViewController.h"
#import "LoginView.h"
#import "LoginPresenter.h"

@interface ViewController () <LoginViewDelegate>

@property (nonatomic, strong) LoginPresenter *loginPresenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _loginPresenter = [[LoginPresenter alloc] init];
    [_loginPresenter attachLoginViewDelegate:self];
    
    [_loginPresenter login:@"mockname" password:@"mockpwd"];
    self.view.backgroundColor = UIColor.cyanColor;
}

- (void)onLoginResult:(NSString *)result {
    NSLog(@"%s login result: %@", __FILE__, result);
}

- (void)didReceiveMemoryWarning {
    [self.loginPresenter detachLoginViewDelegate];
}

@end

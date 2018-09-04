//
//  LoginViewController.m
//  01MVC
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "LoginModel.h"

@interface LoginViewController () <LoginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.orangeColor;
    _loginView = [[LoginView alloc] init];
    _loginView.loginViewDelegate = self;
    [self.view addSubview:_loginView];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"mockname", @"username", @"mockepwd", @"password", nil];
    _loginView.loginModel = [[LoginModel alloc] initWithDict:dict];
}

- (void)onBtnLoginClickWithUsername:(NSString *)username password:(NSString *)password {
    NSLog(@"onBtnLoginClick username:%@, password:%@", username, password);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

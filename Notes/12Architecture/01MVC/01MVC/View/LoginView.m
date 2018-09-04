//
//  LoginView.m
//  01MVC
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "LoginView.h"

@interface LoginView () <UITextFieldDelegate>

//用户名
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UITextField *usernameText;
//密码
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *passwordText;
// 登录按钮
@property (nonatomic, strong) UIButton *btnSure;

@end

@implementation LoginView

- (instancetype)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    //添加主布局
    UIView *mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainView.backgroundColor = UIColor.lightGrayColor;
    mainView.alpha = 0.95;
    [self addSubview:mainView];
    
    //中间显示的view
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, screenWidth - 20, screenHeight - 200)];
    [mainView addSubview:middleView];
    
    //添加用户边框
    UIView *usernameView = [[UIView alloc] init];
    usernameView.frame = CGRectMake(0, 10, screenWidth - 20, 80);
    usernameView.layer.cornerRadius = 8;
    usernameView.layer.borderColor = [[UIColor whiteColor] CGColor];
    usernameView.layer.borderWidth = 1;
    [middleView addSubview:usernameView];
    
    //添加文字框
    _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
    _usernameLabel.text = @"用户名:";
    // 一定这么写居中 不然会报警告的
    _usernameLabel.textAlignment = NSTextAlignmentCenter;
    _usernameLabel.textColor = [UIColor whiteColor];
    [usernameView addSubview:_usernameLabel];
    
    //添加输入框
    _usernameText = [[UITextField alloc] init];
    _usernameText.frame = CGRectMake(100, 20, 150, 40);
    _usernameText.placeholder = @"请输入用户名";
    _usernameText.delegate = self;
    _usernameText.backgroundColor = [UIColor whiteColor];
    [_usernameText setEnablesReturnKeyAutomatically:YES];
    [_usernameText setReturnKeyType:UIReturnKeyDone];
    [usernameView addSubview:_usernameText];
    
    //添加密码框view
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, screenWidth - 20, 80)];
    passwordView.layer.cornerRadius = 8;
    passwordView.layer.borderColor = [[UIColor whiteColor] CGColor];
    passwordView.layer.borderWidth = 1;
    [middleView addSubview:passwordView];

    _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
    _passwordLabel.text = @"密码:";
    _passwordLabel.textAlignment = NSTextAlignmentCenter;
    _passwordLabel.textColor = [UIColor whiteColor];
    [passwordView addSubview:_passwordLabel];
   
    //添加密码框
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(100, 20, 150, 40)];
    _passwordText.placeholder = @"请输入密码";
    _passwordText.backgroundColor = [UIColor whiteColor];
    _passwordText.delegate = self;
    [_passwordText setEnablesReturnKeyAutomatically:YES];
    [_passwordText setReturnKeyType:UIReturnKeyDone];
    [_passwordText setSecureTextEntry:YES];
    [passwordView addSubview:_passwordText];
    
    //确定按钮
    _btnSure = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - 80) / 2, screenHeight - 200, 80, 50)];
    [_btnSure setTitle:@"登录" forState:UIControlStateNormal];
    _btnSure.layer.cornerRadius = 15;
    [_btnSure addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:_btnSure];
}

-(void)btnOnClick{
    if(self.loginViewDelegate){
        [self.loginViewDelegate onBtnLoginClickWithUsername:_usernameText.text password:_passwordText.text];
    }
}

- (void)setLoginModel:(LoginModel *)loginModel {
    _loginModel = loginModel;
    
    _usernameText.text = loginModel.username;
    _passwordText.text = loginModel.password;
}

// textfielddelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

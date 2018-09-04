//
//  LoginView.h
//  01MVC
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

@protocol LoginViewDelegate <NSObject>
// 点击登录按钮
- (void)onBtnLoginClickWithUsername:(NSString *)username password:(NSString *)password;

@end

@interface LoginView : UIView
// 代理
@property (nonatomic, assign) id<LoginViewDelegate> loginViewDelegate;
// 登录用户信息
@property (nonatomic, strong) LoginModel *loginModel;

@end


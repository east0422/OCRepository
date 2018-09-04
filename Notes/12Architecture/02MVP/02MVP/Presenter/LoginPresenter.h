//
//  LoginPresenter.h
//  02MVP
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginView.h"

@interface LoginPresenter : NSObject

// 用户名密码登录
- (void)login:(NSString *)username password:(NSString *)password;

// 绑定view即设置代理
- (void)attachLoginViewDelegate:(id<LoginViewDelegate>)loginViewDelegate;

// 解除绑定即删除代理
- (void)detachLoginViewDelegate;

@end

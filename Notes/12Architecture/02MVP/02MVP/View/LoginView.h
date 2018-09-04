//
//  LoginView.h
//  02MVP
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

// 登录代理
@protocol LoginViewDelegate <NSObject>

// 登录结果
- (void)onLoginResult:(NSString *)result;

@end

@interface LoginView : UIView

@end

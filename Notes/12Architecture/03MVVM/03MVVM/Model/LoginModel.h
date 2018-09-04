//
//  LoginModel.h
//  03MVVM
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpUtils.h"

@interface LoginModel : NSObject

// 用户名密码登录
- (void)login:(NSString *)username password:(NSString *)password callback:(Callback)callback;

@end

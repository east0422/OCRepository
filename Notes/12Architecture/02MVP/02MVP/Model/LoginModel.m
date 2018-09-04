//
//  LoginModel.m
//  02MVP
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (void)login:(NSString *)username withPassword:(NSString *)password andCallback:(Callback)callback{
    // 登录验证可能来源数据库、网络、本地文件(json, plist, xml, txt)等等
    [HttpUtils login:username password:password method:@"POST" callback:^(NSString *result) {
        NSLog(@"%s 登录结果: %@", __FILE__, result);
        callback(result);
    }];
}

@end

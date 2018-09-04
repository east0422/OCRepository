//
//  HttpUtils.h
//  02MVP
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Callback)(NSString *result);

@interface HttpUtils : NSObject

// 用户名密码登录
+ (void)login:(NSString *)username password:(NSString *)password method:(NSString *)method callback:(Callback)callback;

@end

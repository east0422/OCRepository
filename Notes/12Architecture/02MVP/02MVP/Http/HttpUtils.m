//
//  HttpUtils.m
//  02MVP
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "HttpUtils.h"

@implementation HttpUtils

// 用户名密码登录
+ (void)login:(NSString *)username password:(NSString *)password method:(NSString *)method callback:(Callback)callback{
    // 创建请求url
    NSURL *url = [NSURL URLWithString:@"127.0.0.1"];
    
    // 创建请求参数
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 设置请求参数
    request.HTTPMethod = method;
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    // 创建请求回话
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建一个请求任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%s login fail and error:%@",__FILE__, error.description);
            callback(@"login fail");
        } else {
            NSLog(@"%s login success", __FILE__);
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            callback(result);
        }
    }];
    
    // 执行任务
    [task resume];
}

@end

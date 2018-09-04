//
//  HttpUtils.m
//  03MVVM
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "HttpUtils.h"

@implementation HttpUtils

+ (void)login:(NSString *)username pasword:(NSString *)password callback:(Callback)callback {
    // 创建url
    NSURL *url = [NSURL URLWithString:@"127.0.0.1"];
    
    // 创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@",username, password];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    // 创建session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            callback(result);
        } else {
            NSLog(@"%s login fail!", __FILE__);
            callback(@"login fail");
        }
    } ];
    
    // 执行task
    [task resume];
}

@end

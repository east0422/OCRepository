//
//  LoginModel.m
//  03MVVM
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (void)login:(NSString *)username password:(NSString *)password callback:(Callback)callback {
    [HttpUtils login:username pasword:password callback:callback];
}

@end

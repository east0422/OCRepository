//
//  LoginModel.m
//  01MVC
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.username = dict[@"username"];
        self.password = dict[@"password"];
    }
    return self;
}

@end

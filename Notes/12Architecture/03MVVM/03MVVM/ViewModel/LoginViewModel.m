//
//  LoginViewModel.m
//  03MVVM
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginModel = [[LoginModel alloc] init];
    }
    return self;
}

@end

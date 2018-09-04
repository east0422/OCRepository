//
//  LoginPresenter.m
//  02MVP
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import "LoginPresenter.h"
#import "LoginModel.h"

@interface LoginPresenter ()

@property (nonatomic, strong) LoginModel *loginModel;
@property (nonatomic, assign) id<LoginViewDelegate> loginViewDelegate;

@end

@implementation LoginPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginModel = [[LoginModel alloc] init];
    }
    return self;
}

- (void)login:(NSString *)username password:(NSString *)password {
    [self.loginModel login:username withPassword:password andCallback:^(NSString *result) {
        if (self.loginViewDelegate != nil) {
            [self.loginViewDelegate onLoginResult:result];
        }
    }];
}

- (void)attachLoginViewDelegate:(id<LoginViewDelegate>)loginViewDelegate {
    self.loginViewDelegate = loginViewDelegate;
}

- (void)detachLoginViewDelegate {
    self.loginViewDelegate = nil;
}

@end

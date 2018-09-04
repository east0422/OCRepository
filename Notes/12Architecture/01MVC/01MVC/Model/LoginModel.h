//
//  LoginModel.h
//  01MVC
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

// 用户名
@property (nonatomic, copy) NSString *username;
// 密码
@property (nonatomic, copy) NSString *password;

-(id)initWithDict:(NSDictionary*)dict;

@end

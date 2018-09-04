//
//  HttpUtils.h
//  03MVVM
//
//  Created by dfang on 2018-9-3.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Callback)(NSString *);

@interface HttpUtils : NSObject

+ (void)login:(NSString *)username pasword: (NSString *)pasword callback:(Callback)callback;

@end

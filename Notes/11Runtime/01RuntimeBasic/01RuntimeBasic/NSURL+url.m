//
//  NSURL+url.m
//  01RuntimeBasic
//
//  Created by dfang on 2018-8-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import "NSURL+url.h"
#import <objc/message.h>

@implementation NSURL (url)

+ (void)load {
    Method urlWithStr = class_getClassMethod([NSURL class], @selector(URLWithString:));
    Method eastUrlWithStr = class_getClassMethod([NSURL class], @selector(eastURLWithString:));
    // 交换两个方法
    method_exchangeImplementations(urlWithStr, eastUrlWithStr);
}

+ (instancetype)eastURLWithString:(NSString *)urlString {
    // 交换后此时调用的eastURLWithString为原始方法URLWithString, 若此处调用URLWithString则会循环调用此方法造成死循环。
    NSURL *url = [NSURL eastURLWithString:urlString];
    if (url == nil) {
        NSLog(@"url is nil");
    }
    return nil;
}

@end

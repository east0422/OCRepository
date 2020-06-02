//
//  main.m
//  02RuntimeMsgForward
//
//  Created by dfang on 2020-5-25.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Man.h"
#import "Woman.h"
#import "ProxyProvider.h"

// 方法调用过程(重定向)
void testMethodForward();
// proxy结合runtime实现方法转发
void testProxyForward();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testMethodForward();
        testProxyForward();
    }
    return 0;
}

void testMethodForward() {
    Woman *xiaohong = [[Woman alloc] init];
    objc_msgSend(xiaohong, NSSelectorFromString(@"run"));
    objc_msgSend(xiaohong, NSSelectorFromString(@"fighting"));
}

void testProxyForward() {
    ProxyProvider *proxy = [ProxyProvider proxyProvider];
    objc_msgSend(proxy, @selector(buy:), @"一斤苹果");
    objc_msgSend(proxy, @selector(order:), @"2份牛肉炒饭");
}

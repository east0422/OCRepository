//
//  ProxyProvider.m
//  02RuntimeMsgForward
//
//  Created by dfang on 2020-5-25.
//  Copyright © 2020 east. All rights reserved.
//

#import "ProxyProvider.h"
#import "FruitShop.h"
#import "Restaurant.h"
#import <objc/runtime.h>

@interface ProxyProvider () {
    NSMutableDictionary *methodMap; // 存储sel及对应的target键值对
}

@end

@implementation ProxyProvider

+ (instancetype)proxyProvider {
    return [[ProxyProvider alloc] init];
}

- (instancetype)init
{
    methodMap = [NSMutableDictionary dictionary];
    [self registerMethodsWithTarget:[FruitShop new]];
    [self registerMethodsWithTarget:[Restaurant new]];
    return self;
}

// 将target中所有方法sel注册到methodMap中，便与后面查找sel对应target
- (void)registerMethodsWithTarget: (id)target {
    unsigned int count = 0;
    Method *methods = class_copyMethodList([target class], &count);
    for (int i = 0; i < count; i++) {
        SEL methodSel = method_getName(methods[i]);
        [methodMap setObject:target forKey:NSStringFromSelector(methodSel)];
    }
    
    free(methods);
}

#pragma --- 重写父类NSProxy方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    id target = methodMap[NSStringFromSelector(sel)];
    if (target && [target respondsToSelector:sel]) {
        return [target methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;
    id target = methodMap[NSStringFromSelector(sel)];
    if (target && [target respondsToSelector:sel]) {
        [invocation invokeWithTarget:target];
    } else {
        return [super forwardInvocation:invocation];
    }
}

@end

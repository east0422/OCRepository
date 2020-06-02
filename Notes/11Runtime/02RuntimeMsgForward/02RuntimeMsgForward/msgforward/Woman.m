//
//  Woman.m
//  01RuntimeBasic
//
//  Created by dfang on 2020-5-20.
//  Copyright © 2020 east. All rights reserved.
//

#import "Woman.h"
#import "Man.h"
#import <objc/message.h>

@implementation Woman

void jump(id self, SEL _cmd) {
    NSLog(@"%@ is jump in %@", self, NSStringFromSelector(_cmd));
}

- (void)run {
    NSLog(@"%@ is run!", NSStringFromClass(self.class));
}

// 1. 首先查找方法是否存在，不存在依次查找父类
//- (void)fighting {
//    NSLog(@"Woman is fighting!");
//}

// 2. 动态方法绑定：没找到对应方法，就调用该方法。使用运行时关联实现后直接执行实现
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if ([NSStringFromSelector(sel) isEqualToString:@"fighting"]) {
//        class_addMethod(self, sel, (IMP)jump, "v@:");
//    }
//    return [super resolveInstanceMethod:sel];
//}

// 3. 重定向：返回一个对象，这个对象会作为消息的新接收者。不能是self自身，否则就是出现无限循环
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if ([NSStringFromSelector(aSelector) isEqualToString:@"fighting"]) {
//        Man *man = [[Man alloc] init];
//        if ([man respondsToSelector:aSelector]) {
//            return man;
//        }
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

// 4.1 转发：重签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"fighting"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

// 4.2 转发：响应处理
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    Man *man = [[Man alloc] init];
    if ([man respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:man];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

// 最后：未处理
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%@找不到方法%@", NSStringFromClass(self.class), NSStringFromSelector(aSelector));
    [super doesNotRecognizeSelector:aSelector];
}

@end

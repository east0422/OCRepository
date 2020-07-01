//
//  main.m
//  03RuntimeMetaClass
//
//  Created by dfang on 2020-6-30.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Parent.h"

// 使用runtime绑定方法实现
void printFunc(id self, SEL _cmd);
// 使用runtime获取元类
void testMetaClass();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        testMetaClass();
    }
    return 0;
}

void testMetaClass () {
    // 创建一个名为Children子类，继承于Parent
    Class newClass = objc_allocateClassPair([Parent class], "Children", 0);
    // 为该类增加一个名为print方法
    class_addMethod(newClass, @selector(print), (IMP)printFunc, "v@:");
    // 注册该类
    objc_registerClassPair(newClass);
    
    // 创建一个Children类的实例
    id instanceOfNewClass = [[newClass alloc] init];
    // 调用 report 方法
    [instanceOfNewClass performSelector:@selector(print)];
}

void printFunc(id self, SEL _cmd)
{
    NSLog(@"This object is %p, meta class is %p", self, object_getClass(self));
    NSLog(@"This object class is %p, class meta class is %p, and super class is %p super class meta class is %p.", [self class], object_getClass([self class]), [self superclass], object_getClass([self superclass]));
    
    Class currentClass = [self class];
    for (int i = 1; i < 8; i++)
    {
        NSLog(@"%d the isa pointer(meta class) is %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    
    NSLog(@"Parent's class is %p, parent meta class is %p", [Parent class], object_getClass([Parent class]));
    NSLog(@"NSObject's class is %p, NSObject meta class is %p", [NSObject class], object_getClass([NSObject class]));
}

//
//  NSObject+KVO.m
//  03KVO
//
//  Created by dfang on 2019-8-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

static const NSString *EASTKVO_PREFIX = @"EastKVONotifying_";

static const char *EASTKVO_OBSERVER = "eastkvo_observer";
static const char *EASTKVO_GETTER = "eastkvo_getter";
static const char *EASTKVO_SETTER = "eastkvo_setter";

@implementation NSObject (KVO)

void setName(id self, SEL _cmd, NSString *newname) {
    NSLog(@"自定义观察者分类: %@, %@, %@", self, NSStringFromSelector(_cmd), newname);
    // 保存当前类
    Class curClass = [self class];
    // 获取父类
    Class superClass = class_getSuperclass(curClass);
    // 将self的isa指针指向父类
    object_setClass(self, superClass);
    // 调用父类方法 //////// 切记不能使用superclass /////////
    objc_msgSend(self, _cmd, newname);
    // 取出观察者
    id observer = objc_getAssociatedObject(self, EASTKVO_OBSERVER);
    // 通知观察者
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:), @"name", self, newname, nil);
    // 将isa指向改回子类
    object_setClass(self, curClass);
}

void setMethod(id self, SEL _cmd, id newValue) {
    // 获取get、set方法名
    NSString *getNameStr = objc_getAssociatedObject(self, EASTKVO_GETTER);
    NSString *setNameStr = objc_getAssociatedObject(self, EASTKVO_SETTER);
    
    // 获取当前类型以便后期恢复isa指针
    Class curClass = [self class];
    
    // isa指向父类
    object_setClass(self, class_getSuperclass(curClass));
    
    // 调用原类get方法，获取oldValue
    id oldValue = objc_msgSend(self, NSSelectorFromString(getNameStr));
    // 调用原类set方法
    objc_msgSend(self, NSSelectorFromString(setNameStr), newValue);
    
    // 获取观察者并调用观察者方法
    id observer = objc_getAssociatedObject(self, EASTKVO_OBSERVER);
    
    NSMutableDictionary *change = @{}.mutableCopy;
    if (newValue) {
        change[NSKeyValueChangeNewKey] = newValue;
    }
    if (oldValue) {
        change[NSKeyValueChangeOldKey] = oldValue;
    }
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:), getNameStr, self, change, nil);
    
    // 将isa指向子类
    object_setClass(self, curClass);
}

- (void)east_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    // 动态添加一个类，模拟子类NSKVONotifying_A的产生
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *subClassName = [EASTKVO_PREFIX stringByAppendingString:oldClassName];
    // 获取新类是否存在
    Class subClass = objc_getClass([subClassName UTF8String]);
    if (subClass == nil) {
        // 定义一个新类
        subClass = objc_allocateClassPair([self class], [subClassName UTF8String], 0);
        // 注册新添加的类
        objc_registerClassPair(subClass);
    }
   
    // set方法首字母大写
    NSString *keyPathChange = [[[keyPath substringToIndex:1] uppercaseString] stringByAppendingString:[keyPath substringFromIndex:1]];
    NSString *setNameStr = [NSString stringWithFormat:@"set%@:", keyPathChange];
    SEL setSEL = NSSelectorFromString(setNameStr);
    
//    // 添加setName方法
//    class_addMethod(subClass, @selector(setName:), (IMP)setName, "v@:@");
    
    // 添加setter方法
    Method sMethod = class_getInstanceMethod([self class], setSEL);
    const char *types = method_getTypeEncoding(sMethod);
    class_addMethod(subClass, setSEL, (IMP)setMethod, types);
    
    // 将指向被观察者的isa指针指向新的子类
    object_setClass(self, subClass);
    
    // 将观察者的属性保存到新子类中
    objc_setAssociatedObject(self, EASTKVO_OBSERVER, observer, OBJC_ASSOCIATION_ASSIGN);
    
    // 保存set、get方法名
    objc_setAssociatedObject(self, EASTKVO_SETTER, setNameStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, EASTKVO_GETTER, keyPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)east_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    
}

@end

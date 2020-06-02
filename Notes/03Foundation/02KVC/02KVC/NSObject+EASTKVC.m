//
//  NSObject+EASTKVC.m
//  02KVC
//
//  Created by dfang on 2020-5-12.
//  Copyright © 2020 east. All rights reserved.
//

#import "NSObject+EASTKVC.h"
#import <AppKit/AppKit.h>
#import <objc/runtime.h>

@implementation NSObject (EASTKVC)

- (id)EAST_valueForKey:(NSString *)key {
    // 判断key是否合法
    if (key == nil || key.length == 0) {
        return nil;
    }
    
    // 调用getter方法
    NSString *getKeyMethod = [NSString stringWithFormat:@"get%@", key.capitalizedString];
    if ([self respondsToSelector:NSSelectorFromString(getKeyMethod)]) {
        return [self performSelector:NSSelectorFromString(getKeyMethod)];
    }
    
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        return [self performSelector:NSSelectorFromString(key)];
    }
    
    NSString *_keyMethod = [NSString stringWithFormat:@"_%@", key];
    if ([self respondsToSelector:NSSelectorFromString(_keyMethod)]) {
        return [self performSelector:NSSelectorFromString(_keyMethod)];
    }
    
    // accessInstanceVariablesDirectly是否为NO
    if (![self.class accessInstanceVariablesDirectly]) {
        NSException *exception = [NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"accessInstanceVariablesDirectly返回NO" userInfo:nil];
        @throw exception;
        return nil;
    }
    
    // 使用runtime访问成员属性
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    NSMutableArray *arr = NSMutableArray.array;
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *varName = ivar_getName(ivar);
        [arr addObject:[NSString stringWithUTF8String:varName]];
    }
    // 释放
    free(ivars);
    
//    NSLog(@"arr: %@", arr);
    
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    if ([arr indexOfObject:_key] != NSNotFound) {
        Ivar _keyivar = class_getInstanceVariable(self.class, _key.UTF8String);
        return object_getIvar(self, _keyivar);
    }
    
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", key.capitalizedString];
    if ([arr indexOfObject:_isKey] != NSNotFound) {
        Ivar _isKeyivar = class_getInstanceVariable(self.class, _isKey.UTF8String);
        return object_getIvar(self, _isKeyivar);
    }
    
    if ([arr indexOfObject:key] != NSNotFound) {
        Ivar keynameivar = class_getInstanceVariable(self.class, key.UTF8String);
        return object_getIvar(self, keynameivar);
    }
    
    NSString *isKey = [NSString stringWithFormat:@"is%@", key.capitalizedString];
    if ([arr indexOfObject:isKey] != NSNotFound) {
       Ivar isKeyivar = class_getInstanceVariable(self.class, isKey.UTF8String);
       return object_getIvar(self, isKeyivar);
    }
    
    return [self valueForUndefinedKey:key];
}

- (void)EAST_setValue:(id)value forKey:(NSString *)key {
    // 判断key是否合法
    if (key == nil || key.length == 0) {
//        NSException *exception = [NSException exceptionWithName:@"EAST_setValue:forKey:" reason:@"key is illegal" userInfo:nil];
//        @throw exception;
        return;
    }
    
    // 调用setter方法
    NSString *setKeyMethod = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
    if ([self respondsToSelector:NSSelectorFromString(setKeyMethod)]) {
        [self performSelector:NSSelectorFromString(setKeyMethod) withObject:value];
        return;
    }
    
    NSString *_setKeyMethod = [NSString stringWithFormat:@"_set%@:", key.capitalizedString];
    if ([self respondsToSelector:NSSelectorFromString(_setKeyMethod)]) {
        [self performSelector:NSSelectorFromString(_setKeyMethod) withObject:value];
        return;
    }
    
    NSString *setIsKeyMethod = [NSString stringWithFormat:@"setIs%@:", key.capitalizedString];
    if ([self respondsToSelector:NSSelectorFromString(setIsKeyMethod)]) {
        [self performSelector:NSSelectorFromString(setIsKeyMethod) withObject: value];
        return;
    }
    
    // 自定义响应方法
    NSString *setTestKeyMethod = [NSString stringWithFormat:@"setTest%@:", key.capitalizedString];
    if ([self respondsToSelector:NSSelectorFromString(setTestKeyMethod)]) {
        [self performSelector:NSSelectorFromString(setTestKeyMethod) withObject: value];
        return;
    }
    
    // accessInstanceVariablesDirectly是否为NO
    if (![self.class accessInstanceVariablesDirectly]) {
        NSException *exception = [NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"accessInstanceVariablesDirectly返回NO" userInfo:nil];
        @throw exception;
        return;
    }
    
    // 使用runtime访问成员属性
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    NSMutableArray *arr = NSMutableArray.array;
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *varName = ivar_getName(ivar);
        [arr addObject:[NSString stringWithUTF8String:varName]];
    }
    // 释放
    free(ivars);
    
//    NSLog(@"arr: %@", arr);
    
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    if ([arr indexOfObject:_key] != NSNotFound) {
        Ivar _keyivar = class_getInstanceVariable(self.class, _key.UTF8String);
        object_setIvar(self, _keyivar, value);
        return;
    }
    
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", key.capitalizedString];
    if ([arr indexOfObject:_isKey] != NSNotFound) {
        Ivar _isKeyivar = class_getInstanceVariable(self.class, _isKey.UTF8String);
        object_setIvar(self, _isKeyivar, value);
        return;
    }
    
    NSString *keyname = [NSString stringWithFormat:@"%@", key];
    if ([arr indexOfObject:keyname] != NSNotFound) {
        Ivar keynameivar = class_getInstanceVariable(self.class, keyname.UTF8String);
        object_setIvar(self, keynameivar, value);
        return;
    }
    
    NSString *isKey = [NSString stringWithFormat:@"is%@", key.capitalizedString];
    if ([arr indexOfObject:isKey] != NSNotFound) {
       Ivar isKeyivar = class_getInstanceVariable(self.class, isKey.UTF8String);
       object_setIvar(self, isKeyivar, value);
       return;
    }
    
    [self setValue:value forUndefinedKey:key];
}

@end

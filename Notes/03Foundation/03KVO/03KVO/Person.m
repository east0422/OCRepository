//
//  Person.m
//  03KVO
//
//  Created by dfang on 2019-8-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//        [self addObserver:self forKeyPath:@"nickName" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

// 只处理dog属性
//+ (NSSet<NSString *> *)keyPathsForValuesAffectingDog
//{
//    // 实际应用中可使用运行时获取对象属性
//    return [NSSet setWithObjects: @"_dog.name", @"_dog.age", nil];
//
//}

// 处理所有key，依据不同key做不同响应处理
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keypaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"dog"]) {
        keypaths = [keypaths setByAddingObjectsFromArray:@[@"_dog.name", @"_dog.age"]];
    }
    return keypaths;
}

// 默认为YES，自动通知，若返回NO则需要手动通知(主动调用willChangeValueForKey:和didChangeValueForKey:)
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"观察到了%@的属性%@变化为%@", object, keyPath, change);
}

- (NSString *)nickname {
    return self->nickname;
}
- (void)setNickname: (NSString *)nickname {
    self->nickname = nickname;
}

- (void)dealloc
{
    NSLog(@"person dealloc");
//    [self removeObserver:self forKeyPath:@"name" context:nil];
//    [self removeObserver:self forKeyPath:@"nickName" context:nil];
}

@end

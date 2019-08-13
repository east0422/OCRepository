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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"观察到了%@的属性%@变化为%@", object, keyPath, change);
}

- (void)setNickName: (NSString *)nickname {
    nickName = nickname;
}

- (void)dealloc
{
    NSLog(@"person dealloc");
//    [self removeObserver:self forKeyPath:@"name" context:nil];
//    [self removeObserver:self forKeyPath:@"nickName" context:nil];
}

@end

//
//  Baby.m
//  03KVO
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Baby.h"

@implementation Baby

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hungryLevel = 100;
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eat) userInfo:nil repeats:YES];
    }
    return self;
}

// 定时器任务KVO: 属性变化想要被监听到，需要调用set(KVC)
- (void)eat {
    NSLog(@"hungryLevel:%ld", (long)self.hungryLevel);
    self.hungryLevel -= 1;
    // 属性赋值并没有调用对应的set方法
//    _hungryLevel -= 1;
}

@end

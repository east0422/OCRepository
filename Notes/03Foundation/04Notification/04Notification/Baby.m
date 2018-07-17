//
//  Baby.m
//  04Notification
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
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)action {
    _hungryLevel--;
    if (_hungryLevel < 95) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hungryValueCenter" object:self userInfo: [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_hungryLevel], @"hungryLevel", nil]];
    }
}

- (void)dealloc
{
    // 移除全部通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"hungry level is %d", _hungryLevel];
}

@end

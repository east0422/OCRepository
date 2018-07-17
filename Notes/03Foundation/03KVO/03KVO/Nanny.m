//
//  Nanny.m
//  03KVO
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Nanny.h"
#import "Baby.h"

@implementation Nanny

- (id)initWithBaby:(Baby *)baby {
    self = [super init];
    if (self) {
        _baby = baby;
        // 添加观察者
        [_baby addObserver: self forKeyPath: @"hungryLevel" options: NSKeyValueObservingOptionOld context: nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"hungryLevel"]) {
        if (_baby.hungryLevel < 90) {
            NSLog(@"baby is hungry!");
            _baby.hungryLevel = 100;
        }
    }
}

- (void)dealloc
{
    [_baby removeObserver:self forKeyPath:@"hungryLevel"];
}

@end

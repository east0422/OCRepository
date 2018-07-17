//
//  Nanny.m
//  04Notification
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(babyHungryWithNotify:) name:@"hungryValueCenter" object:nil];
    }
    return self;
}

- (void)babyHungryWithNotify:(NSNotification *)notify {
//    if (notify && [notify.object isKindOfClass:[Baby class]]) { // get object
//        Baby *baby = notify.object;
//        NSLog(@"baby:%@", baby);
//    }
    NSLog(@"noify:%@", notify);
    NSLog(@"baby is hungry");
}

@end

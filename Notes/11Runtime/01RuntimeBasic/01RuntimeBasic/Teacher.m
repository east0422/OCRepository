//
//  Teacher.m
//  01RuntimeBasic
//
//  Created by dfang on 2018-8-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Teacher.h"
#import <objc/message.h>

@implementation Teacher

- (void)eatFish {
    NSLog(@"teacher %@ eat fish free!", self.name);
}

// 懒加载方法
void criticism(id sel, SEL _cmd, NSString *stuName) {
    Teacher *t = sel;
    NSLog(@"%@ criticism %@ because Naughty", t.name, stuName);
}

// 动态添加方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(hit:)) {
        class_addMethod([Teacher class], sel, (IMP)criticism, "v@:*");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end

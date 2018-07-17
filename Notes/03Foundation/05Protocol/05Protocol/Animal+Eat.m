//
//  Animal+Eat.m
//  05Protocol
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Animal+Eat.h"

@protocol AnimalProtocol <NSObject>

- (void)eatFood;

@end

@implementation Animal (Eat)

- (void)test11 {
    NSLog(@"%s", __func__);
}

- (void)test12 {
    NSLog(@"%s", __func__);
}

@end

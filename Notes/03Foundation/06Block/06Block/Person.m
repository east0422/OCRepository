//
//  Person.m
//  06Block
//
//  Created by dfang on 2019-9-2.
//  Copyright © 2019年 east. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)eat:(void(^)(void))block {
    block();
}

- (void (^)(void))eatWithFood:(NSString *)food {
    return ^(void) {
        NSLog(@"eat with %@", food);
    };
}

- (void (^)(NSString * _Nonnull))eatWith {
    return ^(NSString *food) {
        NSLog(@"eat with %@", food);
    };
}

@end

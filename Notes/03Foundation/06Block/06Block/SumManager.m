//
//  SumManager.m
//  06Block
//
//  Created by dfang on 2019-9-3.
//  Copyright © 2019年 east. All rights reserved.
//

#import "SumManager.h"

@implementation SumManager

- (SumManager *(^)(int))add {
    return ^(int value) {
        self->_result += value;
        return self;
    };
}

@end

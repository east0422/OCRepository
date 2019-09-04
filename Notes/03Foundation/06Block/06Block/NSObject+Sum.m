//
//  NSObject+Sum.m
//  06Block
//
//  Created by dfang on 2019-9-3.
//  Copyright © 2019年 east. All rights reserved.
//

#import "NSObject+Sum.h"
#import "SumManager.h"

@implementation NSObject (Sum)

+ (int)sum:(void (^)(SumManager *sumManagerMaker))block {
    SumManager *mgr = [[SumManager alloc] init];
    block(mgr);
    return mgr.result;
}

@end

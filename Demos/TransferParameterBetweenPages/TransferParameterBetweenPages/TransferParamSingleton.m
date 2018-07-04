//
//  TransferParamSingleton.m
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import "TransferParamSingleton.h"

static TransferParamSingleton *singleton = nil;

@implementation TransferParamSingleton

+ (instancetype)defaultSingleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[TransferParamSingleton alloc] init];
    });
    
    return singleton;
}

@end

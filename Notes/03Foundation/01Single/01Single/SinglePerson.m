//
//  SinglePerson.m
//  01Single
//
//  Created by dfang on 2018-8-17.
//  Copyright © 2018年 east. All rights reserved.
//

#import "SinglePerson.h"

static SinglePerson *person;

@implementation SinglePerson

+ (SinglePerson *)singlePersonInstance {
    if (person == nil) {
        person = [[self alloc] init];
    }
    return person;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (person == nil) {
        person = [super allocWithZone:zone];
    }
    return person;
}

@end

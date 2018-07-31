//
//  Teacher.m
//  RuntimeArchived
//
//  Created by dfang on 2018-7-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Teacher.h"
#import <objc/runtime.h>

@implementation Teacher

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([Teacher class], &count);
        for (int i = 0; i < count; ++i) {
            const char *name = ivar_getName(ivars[i]);
            NSString *key = [[NSString alloc] initWithUTF8String:name];
            
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([Teacher class], &count);
    for (int i = 0; i < count; ++i) {
        const char *name = ivar_getName(ivars[i]);
        NSString *key = [[NSString alloc] initWithUTF8String:name];

        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, address:%@, tel:%@, email:%@, spouse:%@", [super description], _address, _tel, _email, _spouse];
}

@end

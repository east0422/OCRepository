//
//  Person.m
//  RuntimeArchived
//
//  Created by dfang on 2018-7-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([Person class], &count); // use [Person class] not [self class];
        
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
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        const char *name = ivar_getName(ivars[i]);
        NSString *key = [[NSString alloc] initWithUTF8String:name];
        
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Person(name: %@, age: %ld, sex: %ld)", _name, (long)_age, (long)_sex];
}

@end

//
//  Person.m
//  01Predicate
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (id)personWithAge:(NSInteger)age andHeight:(NSInteger)height {
    Person *person = [[Person alloc] init];
    person.age = age;
    person.height = height;
    return person;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"age=%ld,height=%ld", (long)_age, (long)_height];
}

@end

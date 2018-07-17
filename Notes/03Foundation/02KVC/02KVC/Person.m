//
//  Person.m
//  02KVC
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)setAge:(int)age{
    NSLog(@"call setAge age is %d", age);
    _age = age;
}

- (int)age{
    NSLog(@"call age and age is %d", _age);
    return _age;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name is %@, age is %d", name, _age];
}

@end

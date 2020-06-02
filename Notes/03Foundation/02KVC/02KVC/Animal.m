//
//  Animal.m
//  02KVC
//
//  Created by dfang on 2020-5-12.
//  Copyright © 2020 east. All rights reserved.
//

#import "Animal.h"

@implementation Animal

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"_name";
        _isName = @"_isName";
        name = @"name";
        isName = @"isName";
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"_name:%@, _isName:%@, name:%@, isName:%@", _name, _isName, name, isName];
}

//- (void)setName:(NSString *)name {
//    NSLog(@"Animal %@ %@", NSStringFromSelector(_cmd), name);
//}
//
//- (void)_setName:(NSString *)name {
//    NSLog(@"Animal %@ %@", NSStringFromSelector(_cmd), name);
//}
//
//- (void)setIsName:(NSString *)name {
//    NSLog(@"Animal %@ %@", NSStringFromSelector(_cmd), name);
//}
//
//- (void)setTestName:(NSString *)name {
//    NSLog(@"Animal %@ %@", NSStringFromSelector(_cmd), name);
//}

// 默认返回YES，返回NO不再查找成员变量
//+ (BOOL)accessInstanceVariablesDirectly {
//    return NO;
//}

@end

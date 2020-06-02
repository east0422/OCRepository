//
//  Human.m
//  02KVC
//
//  Created by dfang on 2020-5-11.
//  Copyright © 2020 east. All rights reserved.
//

#import "Human.h"

@implementation Human

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"_name";
        _isName = true;
        name = @"name";
        isName = @"isName";
        
//        isname= @"isname";
    }
    return self;
}

//- (NSString *)getName {
//    return @"getName11";
//}
//
//- (NSString *)name {
//    return @"name11";
//}
//
//- (NSString *)isName {
//    return @"isName11";
//}
//
//- (NSString *)_name {
//    return @"_name11";
//}

//- (NSInteger)countOfName {
//    return 5;
//}
//
//- (id)objectInNameAtIndex:(NSInteger)index {
//    return [@"human" stringByAppendingFormat:@"%li", (long)index];
//}

//// 默认为YES，返回NO时不会查找成员变量
+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"undefined key: %@", key);
    return nil;
}

//- (void)setName:(NSString *)name {
//    NSLog(@"setName:%@", name);
//}

//- (void)_setName:(NSString *)name {
//    NSLog(@"_setName:%@", name);
//}
//
//- (void)setIsName:(NSString *)name {
//    NSLog(@"setIsName:%@", name);
//}

- (NSString *)description
{
    return [NSString stringWithFormat:@"_name:%@, _isName:%@, name:%@, isName:%@", _name, _isName?@"YES":@"NO", name, isName];
}

@end

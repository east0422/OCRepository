//
//  Person.m
//  01RuntimeBasic
//
//  Created by dfang on 2018-8-30.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Person.h"

@interface Person() {
     NSString *tel; // 电话
}

// 体重
@property (nonatomic, assign) NSUInteger weight;

@end

@implementation Person

- (void)eatWith:(NSString *)food {
    NSLog(@"%@ eat %@!", self.name, food);
}

- (void)drinkWater {
    NSLog(@"%@ drink water!", self.name);
}

+ (void)drinkWater {
    NSLog(@"Person drink water!");
}

+ (void)eatRice {
    NSLog(@"Person eat rice!");
}

//- (NSString *)description
//{
//    // address and height not access
//    return [NSString stringWithFormat:@"name: %@, age: %ld, sex: %lu", _name, (long)_age, (unsigned long)_sex];
//}

@end

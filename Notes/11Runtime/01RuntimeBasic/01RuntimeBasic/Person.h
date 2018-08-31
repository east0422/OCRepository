//
//  Person.h
//  01RuntimeBasic
//
//  Created by dfang on 2018-8-30.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Female,
    Male,
} SEX;

@interface Person : NSObject {
    NSString *address; // 地址
    NSInteger height; // 身高
}

// 姓名
@property (nonatomic, copy) NSString *name;
// 性别
@property (nonatomic, assign) SEX sex;
// 年龄
@property (nonatomic, assign) NSInteger age;

// 吃食物
- (void)eatWith:(NSString *)food;
// 喝水
- (void)drinkWater;

// 类方法
// 喝水
+ (void)drinkWater;
// 吃米饭
+ (void)eatRice;

@end

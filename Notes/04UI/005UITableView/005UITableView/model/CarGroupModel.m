//
//  CarGroupModel.m
//  005UITableView
//
//  Created by dfang on 2019-10-28.
//  Copyright © 2019年 east. All rights reserved.
//

#import "CarGroupModel.h"
#import "CarModel.h"

@implementation CarGroupModel

+ (instancetype)initWithDict:(NSDictionary *)dict {
    CarGroupModel *carGroup = [[CarGroupModel alloc] init];
    
//    carGroup.brand = [dict valueForKey:@"brand"];
//    carGroup.remark = [dict valueForKey:@"remark"];
//    
//    NSMutableArray *cars = [NSMutableArray array];
//    NSArray *carDics = [dict valueForKey:@"cars"];
//    for (NSDictionary *carDic in carDics) {
//        [cars addObject:[CarModel initWithDict:carDic]];
//    }
//    carGroup.cars = cars;
    
    // kvo, 对特殊类型需要在setValue:(id)value forKey:(NSString *)key单独处理
    [carGroup setValuesForKeysWithDictionary:dict];
    return carGroup;
}

// 发现未标识的字符 防止意外崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) { // id为关键字
        self.ID = value;
    } else {
        NSLog(@"UndefinedKey:%@", key);
    }
}

// 对特殊类型需要在setValue:(id)value forKey:(NSString *)key单独处理
- (void)setValue:(id)value forKey:(NSString *)key {
//    NSLog(@"key:%@, value:%@", key, value);
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"cars"]) {
        NSMutableArray *cars = [NSMutableArray array];
        for (NSDictionary *carDic in value) {
            [cars addObject:[CarModel initWithDict:carDic]];
        }
        self.cars = cars;
    }
}

@end

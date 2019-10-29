//
//  CarModel.m
//  005UITableView
//
//  Created by dfang on 2019-10-28.
//  Copyright © 2019年 east. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

+ (instancetype)initWithDict:(NSDictionary *)dict {
    CarModel *car = [[CarModel alloc] init];
    
//    car.name = [dict valueForKey:@"name"];
//    car.icon = [dict valueForKey:@"icon"];
//    car.price = [dict valueForKey:@"price"];
    
    // KVC，通过key设置value
    [car setValuesForKeysWithDictionary:dict];
    return car;
}

@end

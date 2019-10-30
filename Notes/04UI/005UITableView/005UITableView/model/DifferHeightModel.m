//
//  DifferHeightModel.m
//  005UITableView
//
//  Created by dfang on 2019-10-30.
//  Copyright © 2019年 east. All rights reserved.
//

#import "DifferHeightModel.h"

@implementation DifferHeightModel

+ (instancetype)initWithDic:(NSDictionary *)dic {
    DifferHeightModel *differHeightModel = [[self alloc] init];
    [differHeightModel setValuesForKeysWithDictionary:dic];
    return differHeightModel;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"undefinedkey: %@, value: %@", key, value);
}

@end

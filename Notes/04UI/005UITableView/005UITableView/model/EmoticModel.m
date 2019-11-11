//
//  EmoticModel.m
//  005UITableView
//
//  Created by dfang on 2019-11-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import "EmoticModel.h"

@implementation EmoticModel

+ (instancetype)initWithDic:(NSDictionary *)dic {
    EmoticModel *emotic = [[EmoticModel alloc] init];
    [emotic setValuesForKeysWithDictionary:dic];
    return emotic;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%s--%s: %@ -> %@", __FILE__, __func__, key, value);
}

@end

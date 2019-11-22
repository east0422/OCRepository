//
//  AppInfo.m
//  003NSOperation
//
//  Created by dfang on 2019-11-22.
//  Copyright © 2019 east. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

+ (instancetype)initWithDic:(NSDictionary *)dic {
    AppInfo *appInfo = [[self alloc] init];
    [appInfo setValuesForKeysWithDictionary:dic];
    return appInfo;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"file:%s, func:%s, undefinedkey:%@, value:%@", __FILE__, __func__, key, value);
}

@end

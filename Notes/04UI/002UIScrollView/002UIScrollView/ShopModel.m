//
//  ShopModel.m
//  002UIScrollView
//
//  Created by dfang on 2019-9-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

+ (instancetype)shopWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.iconName = [dic objectForKey:@"icon"];
        self.title = [dic objectForKey:@"title"];
    }
    return self;
}

@end

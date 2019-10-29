//
//  CarModel.h
//  005UITableView
//
//  Created by dfang on 2019-10-28.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarModel : NSObject

@property (nonatomic, copy) NSString *name; // 名称
@property (nonatomic, copy) NSString *icon; // 图片
@property (nonatomic, copy) NSString *price; // 价格

+ (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

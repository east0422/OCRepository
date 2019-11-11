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

/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 图片 */
@property (nonatomic, copy) NSString *icon;
/** 价格 */
@property (nonatomic, copy) NSString *price;

/** 以字典实例化汽车模型对象 */
+ (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

//
//  CarGroupModel.h
//  005UITableView
//
//  Created by dfang on 2019-10-28.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarGroupModel : NSObject

/** 品牌名称 */
@property (nonatomic, copy) NSString *brand;
/** 组备注 */
@property (nonatomic, copy) NSString *remark;
/** 该组中的汽车数组 */
@property (nonatomic, strong) NSArray *cars;
/** 唯一标识ID，id为关键字所以需要用大写或取个别名 */
@property (nonatomic, copy) NSString *ID;

/** 字典对象实例化车组对象 */
+ (instancetype)initWithDict: (NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

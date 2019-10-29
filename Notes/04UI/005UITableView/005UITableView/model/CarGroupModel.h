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

@property (nonatomic, copy) NSString *brand; // 品牌名称
@property (nonatomic, copy) NSString *remark; // 备注
@property (nonatomic, strong) NSArray *cars; // 该组中的汽车
@property (nonatomic, copy) NSString *ID;

+ (instancetype)initWithDict: (NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

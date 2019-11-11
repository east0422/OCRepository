//
//  EmoticModel.h
//  005UITableView
//
//  Created by dfang on 2019-11-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmoticModel : NSObject

/** 表情图片 */
@property (nonatomic, copy) NSString *icon;
/** 表情描述 */
@property (nonatomic, copy) NSString *desc;

/** 字典实例化表情模型对象 */
+ (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

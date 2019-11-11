//
//  DifferHeightModel.h
//  005UITableView
//
//  Created by dfang on 2019-10-30.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DifferHeightModel : NSObject

/** 文本内容 */
@property (nonatomic, copy) NSString *text;
/** 图像 */
@property (nonatomic, copy) NSString *icon;
/** 内容图片 */
@property (nonatomic, copy) NSString *picture;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 是否vip */
@property (nonatomic, assign, getter=isVip) Boolean vip;
/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 字典对象实例化对象 */
+ (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

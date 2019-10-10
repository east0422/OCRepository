//
//  ShopModel.h
//  002UIScrollView
//
//  Created by dfang on 2019-9-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopModel : NSObject

// 商品图片
@property (nonatomic, copy) NSString *iconName;
// 商品标签
@property (nonatomic, copy) NSString *title;

+ (instancetype)shopWithDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

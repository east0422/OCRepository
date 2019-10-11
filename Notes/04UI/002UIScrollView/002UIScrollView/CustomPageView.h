//
//  CustomPageView.h
//  002UIScrollView
//
//  Created by dfang on 2019-10-10.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomPageView : UIView

+ (instancetype)pageView; // 实例方法初始化视图
@property (nonatomic, strong) NSArray *images DEPRECATED_MSG_ATTRIBUTE("建议使用imageNames");
@property (nonatomic, strong) NSArray *imageNames;  // 滚动图片名称数组
@property (nonatomic, strong) UIColor *pageCurColor; // pageControl当前选中颜色
@property (nonatomic, strong) UIColor *pageTintColor; // pageControl未选中颜色
@property (nonatomic, assign) NSTimeInterval timeInterval; // 图片视图自动切换间隔秒数

@end

NS_ASSUME_NONNULL_END

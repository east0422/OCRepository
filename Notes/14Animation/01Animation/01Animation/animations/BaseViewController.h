//
//  BaseViewController.h
//  01Animation
//  子类继承并覆盖对应的方法来实现不同功能子控制器
//
//  Created by dfang on 2019-6-4.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

// 控制器标题
- (NSString *)controllerTitle;

// 按钮标题及点击按钮响应方法字典数组(eg {title: 'aa', selector: 'methodAA'})
- (NSArray *)btnTitlesAndSelectors;

// 初始化视图
- (void)initViews;

@end

NS_ASSUME_NONNULL_END

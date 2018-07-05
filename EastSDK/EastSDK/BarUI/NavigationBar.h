//
//  NavigationBar.h
//  EastSDK
//
//  Created by dfang on 2018-7-5.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBar : UIImageView

// 标题
@property (nonatomic, strong) NSString *title;

// 标题标签
@property (nonatomic, strong) UILabel *titleLabel;

// 左按钮
@property (nonatomic, strong) UIButton *leftButton;

// 右按钮
@property (nonatomic, strong) UIButton *rightButton;

@end

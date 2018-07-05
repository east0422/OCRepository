//
//  NavigationBar.m
//  EastSDK
//
//  Created by dfang on 2018-7-5.
//  Copyright © 2018年 east. All rights reserved.
//

#import "NavigationBar.h"
#import "Constants.h"

@implementation NavigationBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, screenWidth, 44)]) {
        // do something initialization in here
    }
    return self;
}

// 获取标题标签
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, screenWidth - 140, 44)];
        _titleLabel.backgroundColor = sysClearColor();
        _titleLabel.textColor = sysWhiteColor();
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.baselineAdjustment = NSTextAlignmentCenter;
        _titleLabel.font = systemFont(19);
        
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

// 设置标题
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end

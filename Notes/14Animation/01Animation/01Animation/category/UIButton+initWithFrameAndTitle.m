//
//  UIButton+initWithFrameAndTitle.m
//  01Animation
//
//  Created by dfang on 2019-6-4.
//  Copyright © 2019年 east. All rights reserved.
//

#import "UIButton+initWithFrameAndTitle.h"

@implementation UIButton (initWithFrameAndTitle)

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.backgroundColor = [UIColor lightGrayColor];
//        self.titleLabel.text = title; // 不显示
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

@end

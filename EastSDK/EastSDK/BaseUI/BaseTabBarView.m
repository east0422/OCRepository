//
//  BaseTabBarView.m
//  EastSDK
//
//  Created by dfang on 2018-7-5.
//  Copyright © 2018年 east. All rights reserved.
//

#import "BaseTabBarView.h"
#import "Constants.h"

@interface BaseTabBarView ()

@property (nonatomic, weak) UIView *topShadowView;

@end

@implementation BaseTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // UIImageView默认不可交互
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setShowTopShadow:(BOOL)showTopShadow {
    _showTopShadow = showTopShadow;
    
    if (showTopShadow) { // 显示顶部阴影
        // top shadow
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
        sepLine.backgroundColor = sysLightGrayColor();
        sepLine.alpha = 0.4;
        [self addSubview:sepLine];
        
        self.topShadowView = sepLine;
    } else if (self.topShadowView != nil) {
        [self.topShadowView removeFromSuperview];
        self.topShadowView = nil;
    }
}

@end

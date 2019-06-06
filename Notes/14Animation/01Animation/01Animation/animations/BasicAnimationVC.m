//
//  BasicAnimationVC.m
//  01Animation
//
//  Created by dfang on 2019-6-5.
//  Copyright © 2019年 east. All rights reserved.
//

#import "BasicAnimationVC.h"

@interface BasicAnimationVC ()

// 演示视图
@property (nonatomic, strong) UIView *demoView;

@end

@implementation BasicAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.demoView];
}

- (UIView *)demoView {
    if (!_demoView) {
        _demoView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, (SCREEN_HEIGHT - 100)/2, 100, 100)];
        _demoView.backgroundColor = [UIColor redColor];
    }
    return _demoView;
}

// override
- (NSString *)controllerTitle {
    return @"基本动画";
}

// override
- (NSArray *)btnTitlesAndSelectors {
    return @[@{@"title": @"位移", @"selector": @"positionAnimation"},
             @{@"title": @"缩放", @"selector": @"scaleAnimation"},
             @{@"title": @"旋转", @"selector": @"rotateAnimation"},
             @{@"title": @"透明度", @"selector": @"alphaAnimation"},
             @{@"title": @"背景色", @"selector": @"bgColorAnimation"},
            ];
}

// 位移动画
- (void)positionAnimation {
    // 实现思路, 1.frame 值改变加定时器 2.基础动画
    
    // CABasicAnimation创建基础动画
    // 关于animationWithKeyPath的取值问题
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"]; // transform.translation
    // 设置位移值
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2 - 75)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2 - 75)];
    animation.duration = 3.0f;// 移动的时间
    
    // 如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    // animation.fillMode = kCAFillModeForwards;
    // animation.removedOnCompletion = NO;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_demoView.layer addAnimation:animation forKey:nil];
}

// 缩放
- (void)scaleAnimation {
    // 实现思路
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"]; // 同上
    animation.toValue = [NSNumber numberWithFloat:-1.2];
    animation.duration = 4;
    [_demoView.layer addAnimation:animation forKey:nil];
}

// 旋转
- (void)rotateAnimation {
    // 旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];// 绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    animation.toValue = [NSNumber numberWithFloat:M_PI];
    animation.duration = 1.0f;
    [_demoView.layer addAnimation:animation forKey:@"rotateAnimation"];
}

// 透明度
- (void)alphaAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.2f];
    animation.duration = 1.0f;
    [_demoView.layer addAnimation:animation forKey:@"alphaAnimation"];
}

// 背景色
- (void)bgColorAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.toValue =(id) [UIColor greenColor].CGColor;
    animation.duration = 1.0f;
    [_demoView.layer addAnimation:animation forKey:@"backgroundAnimation"];
}

@end

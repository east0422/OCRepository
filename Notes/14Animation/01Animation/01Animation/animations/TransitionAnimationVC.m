//
//  TransitionAnimationVC.m
//  01Animation
//
//  Created by dfang on 2019-6-5.
//  Copyright © 2019年 east. All rights reserved.
//

#import "TransitionAnimationVC.h"

@interface TransitionAnimationVC ()

// 演示视图
@property (nonatomic, strong) UIView *demoView;
// 演示视图标签
@property (nonatomic, strong) UILabel *demoLabel;
// 索引
@property (nonatomic, assign) NSInteger index;

@end

@implementation TransitionAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 0;
    [self.view addSubview:self.demoView];
    [self.view addSubview:self.demoLabel];
    [self changeView:YES];
}

// 懒加载
- (UIView *)demoView {
    if (!_demoView) {
        _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 90, SCREEN_HEIGHT/2 - 200, 180, 260)];
    }
    return _demoView;
}

- (UILabel *)demoLabel {
    if (!_demoLabel) {
        _demoLabel = [[UILabel alloc] initWithFrame:CGRectMake(180/2 - 10, 260/2 - 20, 20, 40)];
        _demoLabel.textAlignment = NSTextAlignmentCenter;
        _demoLabel.font = [UIFont systemFontOfSize:20];
    }
    return _demoLabel;
}

// override
- (NSString *)controllerTitle {
    return @"过渡动画";
}

// TODO: 需要对父控制器selector做修改以兼容有参数及不同参数
- (NSArray *)btnTitlesAndSelectors {
    return @[@{@"title": @"逐渐消失", @"selector": @"fadeAnimation"},
             @{@"title": @"移入", @"selector": @"moveInAnimation"},
             @{@"title": @"推出", @"selector": @"pushAnimation"},
             @{@"title": @"移除", @"selector": @"revealAnimation"},
             @{@"title": @"3D翻滚", @"selector": @"cubeAnimation"},
             @{@"title": @"飘出", @"selector": @"suckEffectAnimation"},
             @{@"title": @"翻转", @"selector": @"oglFlipAnimation"},
             @{@"title": @"动态g覆盖", @"selector": @"rippleEffectAnimation"},
             @{@"title": @"右翻页", @"selector": @"pageCurlAnimation"},
             @{@"title": @"左翻页", @"selector": @"pageUnCurlAnimation"},
             @{@"title": @"相机打开", @"selector": @"cameraIrisHollowOpenAnimation"},
             @{@"title": @"相机关闭", @"selector": @"cameraIrisHollowCloseAnimation"}
            ];
}

/**
 *  管理页面变化
 *  @param isUp 页数是否变化
 */
- (void)changeView : (BOOL)isUp {
    if (self.index > 3) {
        self.index = 0;
    }
    if (self.index < 0) {
        self.index = 3;
    }
    NSArray *colorArray = [NSArray arrayWithObjects:
                           [UIColor cyanColor],
                           [UIColor redColor],
                           [UIColor greenColor],
                           [UIColor orangeColor],
                           nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", nil];
    self.demoView.backgroundColor = colorArray[self.index];
    self.demoLabel.text = titleArray[self.index];
    if (isUp) {
        self.index++;
    } else {
        self.index--;
    }
}

/**
 *  自定义动画方法
 *
 *  @param AnimationType 动画类型  -1 0 1
 */
- (void)transformAnimation:(NSString *)AnimationType {
    [self changeView:YES];
    CATransition *animation = [CATransition animation];
    // 设置动画的类型
    animation.type = AnimationType;
    // 设置动画的方向
    animation.subtype = kCATransitionFromRight;
    // animation.startProgress = 0.3; // 设置动画起点
    // animation.endProgress = 0.8; // 设置动画终点
    animation.duration = 0.8;
    
    [self.demoView.layer addAnimation:animation forKey:AnimationType];
}

- (void)fadeAnimation {
    [self transformAnimation:kCATransitionFade];
}

- (void)moveInAnimation {
    [self transformAnimation:kCATransitionMoveIn];
}

- (void)pushAnimation {
    [self transformAnimation:kCATransitionPush];
}

- (void)revealAnimation {
    [self transformAnimation:kCATransitionReveal];
}

- (void)cubeAnimation {
    [self transformAnimation:@"cube"];
}

- (void)suckEffectAnimation {
    [self transformAnimation:@"suckEffect"];
}

- (void)oglFlipAnimation {
    [self transformAnimation:@"oglFlip"];
}

- (void)rippleEffectAnimation {
    [self transformAnimation:@"rippleEffect"];
}

- (void)pageCurlAnimation {
    [self transformAnimation:@"pageCurl"];
}

- (void)pageUnCurlAnimation {
    [self transformAnimation:@"pageUnCurl"];
}

- (void)cameraIrisHollowOpenAnimation {
    [self transformAnimation:@"cameraIrisHollowOpen"];
}

- (void)cameraIrisHollowCloseAnimation {
    [self transformAnimation:@"cameraIrisHollowClose"];
}

@end

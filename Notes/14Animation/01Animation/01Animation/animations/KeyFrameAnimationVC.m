//
//  KeyFrameAnimationVC.m
//  01Animation
//
//  Created by dfang on 2019-6-5.
//  Copyright © 2019年 east. All rights reserved.
//

#import "KeyFrameAnimationVC.h"

@interface KeyFrameAnimationVC ()

@property (nonatomic, strong) UIView *demoView;

@end

@implementation KeyFrameAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.demoView];
}

- (UIView *)demoView {
    if (!_demoView) {
        _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 25, SCREEN_HEIGHT/2 - 50, 50, 50)];
        _demoView.backgroundColor = [UIColor redColor];
    }
    return _demoView;
}

// override
- (NSString *)controllerTitle {
    return @"关键帧动画";
}

- (NSArray *)btnTitlesAndSelectors {
    return @[@{@"title": @"关键帧", @"selector": @"keyFrameAnimation"},
             @{@"title": @"路径", @"selector": @"pathAnimation"},
             @{@"title": @"抖动", @"selector": @"shakeAnimation"}
             ];
}

// 关键帧动画
- (void)keyFrameAnimation {
    // CABasicAnimation算是CAKeyFrameAnimation的特殊情况，即不考虑中间变换过程，只考虑起始点与目标点就可以了。而CAKeyFrameAnimation则更复杂一些，允许我们在起点与终点间自定义更多内容来达到我们的实际应用需求 所以在使用关键帧动画的时候我们需要给它一个关键帧的路径
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // animation.values 关键帧路径数组
    NSValue *a = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-50)];
    NSValue *b = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-50)];
    NSValue *c = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2+50)];
    NSValue *d = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2+50)];
    NSValue *e = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2-50)];
    NSValue *f = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
    
    animation.values = [NSArray arrayWithObjects:a,b,c,d,e,f, nil];
    animation.duration = 4;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];// 动画节奏设置
    [_demoView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

// 路径动画
-(void)pathAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 路径, 如果你设置了path，那么values将被忽略
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 200)];
    animation.path = path.CGPath;
    animation.duration = 4;
    [_demoView.layer addAnimation:animation forKey:@"pathAnimation"];
}

// 抖动效果
-(void)shakeAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//在这里@"transform.rotation"==@"transform.rotation.z"
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*36];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*4];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*36];
    animation.values = @[value1,value2,value3];
    animation.repeatCount = 10;
    
    [_demoView.layer addAnimation:animation forKey:@"shakeAnimation"];
    
}

@end

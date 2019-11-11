//
//  TransformViewController.m
//  005UITableView
//
//  Created by dfang on 2019-11-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import "TransformViewController.h"

@interface TransformViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;

@end

@implementation TransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/** 演示transform动画 */
- (void)beginTransform {
    // 旋转在前，平移在后
//    CGAffineTransform transform = CGAffineTransformRotate(self.redView.transform, M_PI_4);
//    transform = CGAffineTransformTranslate(transform, 50, 50);
    
    // 平移在前，旋转在后
//    CGAffineTransform transform = CGAffineTransformTranslate(self.redView.transform, 50, 50);
//    transform = CGAffineTransformRotate(transform, M_PI_4);
    
//    [UIView animateWithDuration:3.0 animations:^{
//        self.redView.transform = transform;
//    }];
    
    // 旋转会更改自己的系统坐标方向，分开动画展示更清晰
//    [UIView animateWithDuration:2.0 animations:^{
//        self.redView.transform = CGAffineTransformRotate(self.redView.transform, M_PI_4);
//    }];
//    [UIView animateWithDuration:2.0 delay:3.0 options:(UIViewAnimationOptionTransitionNone) animations:^{
//       self.redView.transform = CGAffineTransformTranslate(self.redView.transform, 50, 50);
//    } completion:nil];
    
    
    [UIView animateWithDuration:2.0 animations:^{
        self.redView.transform = CGAffineTransformTranslate(self.redView.transform, 50, 50);
    }];
    [UIView animateWithDuration:2.0 delay:3.0 options:(UIViewAnimationOptionTransitionNone) animations:^{
        self.redView.transform = CGAffineTransformRotate(self.redView.transform, M_PI_4);
    } completion:nil];
}

// 若响应链上其他都没处理会一直上传到这里
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { 
//    NSLog(@"%s---%s", __FILE__, __func__);
    [self beginTransform];
}

@end

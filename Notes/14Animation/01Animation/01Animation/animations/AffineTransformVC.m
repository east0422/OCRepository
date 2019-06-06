//
//  AffineTransformVC.m
//  01Animation
//
//  Created by dfang on 2019-6-5.
//  Copyright © 2019年 east. All rights reserved.
//

#import "AffineTransformVC.h"

@interface AffineTransformVC ()

@property (strong, nonatomic) UIView *demoView;

@end

@implementation AffineTransformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview: self.demoView];
}

- (UIView *)demoView {
    if (!_demoView) {
        _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-50,50,50)];
        _demoView.backgroundColor = [UIColor redColor];
    }
    return _demoView;
}

- (NSString *)controllerTitle {
    return @"仿射变换";
}

- (NSArray *)btnTitlesAndSelectors {
    return @[@{@"title": @"位移", @"selector": @"positionAnimation"},
             @{@"title": @"缩放", @"selector": @"scaleAnimation"},
             @{@"title": @"旋转", @"selector": @"rotateAnimation"},
             @{@"title": @"组合", @"selector": @"groupAnimation"},
             @{@"title": @"反转", @"selector": @"reverseAnimation"}
             ];
}
             
/**
 *  仿射变换
 *
 *  @param transform transform
 */
 -(void)affineTransformAnimation:(CGAffineTransform)transform {
     self.demoView.transform = CGAffineTransformIdentity;
     [UIView animateWithDuration:1 animations:^{
         self.demoView.transform = transform;
     }];
 }

- (void)positionAnimation {
    [self affineTransformAnimation:CGAffineTransformMakeTranslation(100, 100)];
}

- (void)scaleAnimation {
    [self affineTransformAnimation:CGAffineTransformMakeScale(3,3)];
}

- (void)rotateAnimation {
    [self affineTransformAnimation:CGAffineTransformMakeRotation(M_PI_4)];
}

- (void)groupAnimation {
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(M_PI);
    CGAffineTransform transform2 = CGAffineTransformScale(transform1, 0.5, 0.5);
    [self affineTransformAnimation:CGAffineTransformTranslate(transform2, 100, 100)];
}

- (void)reverseAnimation {
    [self affineTransformAnimation:CGAffineTransformInvert(CGAffineTransformMakeScale(2, 2))];
}

@end

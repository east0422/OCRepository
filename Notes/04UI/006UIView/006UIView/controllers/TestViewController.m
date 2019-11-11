//
//  TestViewController.m
//  006UIView
//
//  Created by dfang on 2019-11-11.
//  Copyright © 2019年 east. All rights reserved.
//

#import "TestViewController.h"
#import "CusView.h"
#import "Masonry.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testIntrinsicContentSize];
    [self testHuggingAndCompressionResistancePriority];
}

/** 测试自定义视图intrinsicSize */
- (void)testIntrinsicContentSize {
    CusView *cusView = [[CusView alloc] init];
    cusView.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:cusView];
    [cusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(80);
    }];
}

/** 视图拉伸和压缩优先级 */
- (void)testHuggingAndCompressionResistancePriority {
    UILayoutPriority chph = [self.view contentHuggingPriorityForAxis:(UILayoutConstraintAxisHorizontal)];
    UILayoutPriority chpv = [self.view contentHuggingPriorityForAxis:(UILayoutConstraintAxisVertical)];
    NSLog(@"contentHuggingPriority h:%f, v:%f", chph, chpv);
    
    UILayoutPriority ccrph = [self.view contentCompressionResistancePriorityForAxis:(UILayoutConstraintAxisHorizontal)];
    UILayoutPriority ccrpv = [self.view contentCompressionResistancePriorityForAxis:(UILayoutConstraintAxisVertical)];
    NSLog(@"contentCompressionResistancePriority h:%f, v:%f", ccrph, ccrpv);
}

@end

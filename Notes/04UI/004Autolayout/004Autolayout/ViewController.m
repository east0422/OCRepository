//
//  ViewController.m
//  004Autolayout
//
//  Created by dfang on 2019-10-23.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ViewController.h"
#import "Masonry/Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *blueView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 添加红蓝两个视图到当前视图中
    _redView = [[UIView alloc] init];
    _redView.backgroundColor = UIColor.redColor;
    // 关闭系统给我们添加的通过Autoresizing转成的约束,默认为YES
    _redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_redView];
    _blueView = [[UIView alloc] init];
    _blueView.backgroundColor = UIColor.blueColor;
    // 关闭系统给我们添加的通过Autoresizing转成的约束,默认为YES
    _blueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_blueView];
    
    // 自动布局测试
//    [self testAutolayout1];
    // VFL
//    [self testVFL1];
    // masonry
    [self testMasonry1];
}

/**
2个view高度相等均为60，右对齐
红色在蓝色上面
红色view距离父控件左、上、右均为30，距离蓝色view间距也为30
蓝色的左边和红色中点对齐
*/
- (void)testAutolayout1 {
    // 为视图添加约束前需先将视图添加到父视图中
    // 红色高度为60
    NSLayoutConstraint *redHeight = [NSLayoutConstraint constraintWithItem:self.redView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:60];
    [self.redView addConstraint:redHeight];
    // 红色距离左侧30
    NSLayoutConstraint *redLeft = [NSLayoutConstraint constraintWithItem:self.redView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeLeft multiplier:1.0 constant:30];
    // 位置约束添加到父视图上
    [self.redView.superview addConstraint:redLeft];
    // 红色距离顶部30
    NSLayoutConstraint *redTop = [NSLayoutConstraint constraintWithItem:self.redView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:30];
    // 位置约束添加到父视图上
    [self.redView.superview addConstraint:redTop];
    // 红色距离右侧30
    NSLayoutConstraint *redRight = [NSLayoutConstraint constraintWithItem:self.redView attribute:(NSLayoutAttributeTrailing) relatedBy:(NSLayoutRelationEqual) toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:30];
    [self.view addConstraint:redRight];
    
    // 蓝色和红色高度相等
    NSLayoutConstraint *blueHeight = [NSLayoutConstraint constraintWithItem:self.blueView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:self.redView attribute:(NSLayoutAttributeHeight) multiplier:1.0 constant:0.0];
    // 相对红色高度需要添加到父视图上
    [self.view addConstraint:blueHeight];
    // 蓝色和红色右对齐
    NSLayoutConstraint *blueRight = [NSLayoutConstraint constraintWithItem:self.blueView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.redView attribute:(NSLayoutAttributeRight) multiplier:1.0 constant:0.0];
    [self.view addConstraint:blueRight];
    // 蓝色距离红色30
    NSLayoutConstraint *blueTop = [NSLayoutConstraint constraintWithItem:self.blueView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.redView attribute:(NSLayoutAttributeBottom) multiplier:1.0 constant:30];
    [self.view addConstraint:blueTop];
    // 蓝色左侧和红色中心对齐
    NSLayoutConstraint *blueLeft = [NSLayoutConstraint constraintWithItem:self.blueView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.redView attribute:(NSLayoutAttributeCenterX) multiplier:1.0 constant:0.0];
    [self.view addConstraint:blueLeft];
}

/**
 2个view高度相等均为60，右对齐
 红色在蓝色上面
 红色view距离父控件左、上、右均为30，距离蓝色view间距也为30
 蓝色的左边和红色中点对齐
 */
- (void)testVFL1 {
    NSDictionary *views = @{@"redView": self.redView, @"blueView": self.blueView};
    NSString *hVFL = @"H:|-(redLeft)-[redView]-redRight-|";
    NSNumber *redLeft = @10;
    NSNumber *redRight = @30;
    // NSDictionaryOfVariableBindings(v1, v2, v3) is equivalent to [NSDictionary dictionaryWithObjectsAndKeys:v1, @"v1", v2, @"v2", v3, @"v3", nil];
    NSDictionary *hMetrics = NSDictionaryOfVariableBindings(redLeft, redRight); // @{@"redLeft": @10, @"redRight": @30};
    NSArray *hLayouts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:kNilOptions metrics:hMetrics views:views];
    [self.view addConstraints:hLayouts];
    
    NSString *vVFL = @"V:|-redTop-[redView(redHeight)]-blueTop-[blueView(==redView)]";
    NSDictionary *vMetrics = @{@"redTop": @50, @"redHeight": @100, @"blueTop": @30};
    NSArray *vLayouts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:NSLayoutFormatAlignAllRight metrics:vMetrics views:views];
    [self.view addConstraints:vLayouts];
    
    // vVFL的options中传参NSLayoutFormatAlignAllRight即可实现右对齐
//    // 蓝色和红色右对齐
//    NSLayoutConstraint *alignRight = [NSLayoutConstraint constraintWithItem:self.blueView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.redView attribute:(NSLayoutAttributeRight) multiplier:1.0 constant:0.0];
//    [self.view addConstraint:alignRight];
    
    // 蓝色左侧和红色中心对齐
    NSLayoutConstraint *blueLeftAlignRedCenter = [NSLayoutConstraint constraintWithItem:self.blueView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.redView attribute:(NSLayoutAttributeCenterX) multiplier:1.0 constant:0.0];
    [self.view addConstraint:blueLeftAlignRedCenter];
}

/**
 2个view高度相等均为60，右对齐
 红色在蓝色上面
 红色view距离父控件左、上、右均为30，距离蓝色view间距也为30
 蓝色的左边和红色中点对齐
 */
- (void)testMasonry1 {
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60); // 高度等于60
        make.left.top.mas_offset(30); // 左、上均为30
        make.right.mas_equalTo(-30); // 距离右30
    }];
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.mas_equalTo(self.redView); // 高度和redView相等,右对齐redView
        make.top.mas_equalTo(self.redView.mas_bottom).offset(30); // 顶部距离redView为30
        make.left.mas_equalTo(self.redView.mas_centerX); // 左边和redView中心对齐
    }];
}

@end

//
//  BaseViewController.m
//  01Animation
//
//  Created by dfang on 2019-6-4.
//  Copyright © 2019年 east. All rights reserved.
//

#import "BaseViewController.h"
#import "UIButton+initWithFrameAndTitle.h"
#import <SWRevealViewController/SWRevealViewController.h>

#define COLUMNS 3

@interface BaseViewController ()

// 头部视图显示title
@property (nonatomic, strong) UIView *headerView;
// 底部视图显示按钮
@property (nonatomic, strong) UIView *footerView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    
    // 注册该页面可以执行滑动切换
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}

- (NSString *)controllerTitle {
    return @"默认标题";
}

- (NSArray *)btnTitlesAndSelectors {
    return @[];
}

- (void)initViews {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.footerView];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _headerView.backgroundColor = BGCOLOR;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.controllerTitle;
        [_headerView addSubview:titleLabel];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = BGCOLOR;
        
        NSInteger sum = self.btnTitlesAndSelectors.count;
        NSInteger rows = (sum % COLUMNS == 0 ? sum / COLUMNS : (sum / COLUMNS) + 1);
        if (rows > 0) {
            CGFloat marginCol = 20;
            CGFloat marginRow = 20;
            CGFloat btnHeight = 30;
            CGFloat btnWidth = (SCREEN_WIDTH - marginCol * (COLUMNS + 1)) / COLUMNS;
            
            _footerView.frame = CGRectMake(0, SCREEN_HEIGHT - ((btnHeight + marginRow) * rows + marginRow), SCREEN_WIDTH, (btnHeight + marginRow) * rows + marginRow);
            
            for (int index = 0; index < sum; index++) {
                NSInteger i = index / COLUMNS;
                NSInteger j = index % COLUMNS;
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(marginCol + (btnWidth + marginCol) * j, marginRow + (btnHeight + marginRow) * i, btnWidth, btnHeight) andTitle:[self.btnTitlesAndSelectors[index] objectForKey:@"title"]];
                btn.tag = index;
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_footerView addSubview:btn];
            }
        }
    }
    return _footerView;
}

- (void)btnClicked:(UIButton *)btn {
    NSString *selName = [self.btnTitlesAndSelectors[btn.tag] objectForKey:@"selector"];
    SEL selector = NSSelectorFromString(selName);
    if ([self respondsToSelector:selector]) {
        // TODO: 更改以兼容有参，多参函数
        //        [self performSelector:selector]; // warning: PerformSelector may cause a leak because its selector is unknown
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    } else {
        NSLog(@"未找到函数%@",selName);
    }
}

@end

//
//  LeftViewController.m
//  01Animation
//
//  Created by dfang on 2019-6-5.
//  Copyright © 2019年 east. All rights reserved.
//

#import "LeftViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "BasicAnimationVC.h"
#import "KeyFrameAnimationVC.h"
#import "GroupAnimationVC.h"
#import "TransitionAnimationVC.h"
#import "AffineTransformVC.h"
#import "IntegrationAnimationVC.h"

@interface LeftViewController () <UITableViewDelegate, UITableViewDataSource>
// 表视图
@property (nonatomic, strong) UITableView *tableView;
// 动画数组
@property (nonatomic, strong) NSArray *animations;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSArray *)animations {
    return @[@{@"title": @"基础动画", @"vc": [[BasicAnimationVC alloc] init]},
             @{@"title": @"关键帧动画", @"vc": [[KeyFrameAnimationVC alloc] init]},
             @{@"title": @"组合动画", @"vc": [[GroupAnimationVC alloc] init]},
             @{@"title": @"过渡动画", @"vc": [[TransitionAnimationVC alloc] init]},
             @{@"title": @"仿射变换", @"vc": [[AffineTransformVC alloc] init]},
             @{@"title": @"综合案例", @"vc": [[IntegrationAnimationVC alloc] init]},
            ];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.animations.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *leftcellIdentifier = @"leftcellidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftcellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftcellIdentifier];
    }
    NSDictionary *animationDic = [self.animations objectAtIndex:indexPath.row];
    cell.textLabel.text = [animationDic objectForKey:@"title"];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWRevealViewController *revealVC = self.revealViewController;
    
    NSDictionary *animationDic = [self.animations objectAtIndex:indexPath.row];
    BaseViewController *vc = [animationDic objectForKey:@"vc"];
    [revealVC pushFrontViewController:vc animated:YES];
}

@end

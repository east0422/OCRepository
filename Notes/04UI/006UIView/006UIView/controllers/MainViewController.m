//
//  MainViewController.m
//  006UIView
//
//  Created by dfang on 2019-11-11.
//  Copyright © 2019年 east. All rights reserved.
//

#import "MainViewController.h"
#import "CategoryTableViewController.h"
#import "DetailTableViewController.h"
#import "Masonry.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *leftCategoryView;
@property (weak, nonatomic) IBOutlet UIView *rightDetailView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CategoryTableViewController *leftVC = [[CategoryTableViewController alloc] init];
    [self addChildViewController:leftVC];
    [self.leftCategoryView addSubview:leftVC.view];
    [leftVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.leftCategoryView);
        make.left.top.mas_offset(0);
    }];
    
    DetailTableViewController *rightVC = [[DetailTableViewController alloc] init];
    [self addChildViewController:rightVC];
    [self.rightDetailView addSubview:rightVC.view];
    [rightVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.rightDetailView);
        make.top.right.mas_offset(0);
    }];
    
    leftVC.cellClickCallback = ^(NSIndexPath * _Nonnull selectIndexPath, NSString * _Nonnull categoryName) {
        rightVC.category = categoryName;
    };
}

@end

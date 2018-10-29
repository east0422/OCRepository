//
//  RunloopNoneViewController.m
//  01Runloop
//
//  Created by dfang on 2018-10-26.
//  Copyright © 2018年 east. All rights reserved.
//

#import "RunloopNoneViewController.h"

@interface RunloopNoneViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImage *shipspaceImage;

@end

@implementation RunloopNoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 160; // 行高
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 不显示分割线
    [self.view addSubview:self.tableView];
}

// 只加载一次节约内存，若图片不同则需要分别添加
- (UIImage *)shipspaceImage {
    if (_shipspaceImage == nil) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
        _shipspaceImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    return _shipspaceImage;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 400;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 最好自定义cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // 删除contentView上面的子控件!! 节约内存!!
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self addLabel:cell indexPath:indexPath];
    
    [self addImage:cell withIndex:0];
    [self addImage:cell withIndex:1];
    [self addImage:cell withIndex:2];
    
    return cell;
}

//添加文字
- (void)addLabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor redColor];
    headerLabel.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", indexPath.row];
    headerLabel.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:headerLabel];
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 115, 300, 35)];
    footerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    footerLabel.numberOfLines = 0;
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    footerLabel.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", indexPath.row];
    footerLabel.font = [UIFont boldSystemFontOfSize:13];
    [cell.contentView addSubview:footerLabel];
}

- (void)addImage:(UITableViewCell *)cell withIndex:(NSInteger)index {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + 100 * index, 30, 85, 85)];
//    imageView.image = self.shipspaceImage; // 若是相同图片可闭幕重复加载占内存
    // 上下滚动会有卡顿，滚动次数过多会因为内存问题而闪退
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    imageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
}

@end

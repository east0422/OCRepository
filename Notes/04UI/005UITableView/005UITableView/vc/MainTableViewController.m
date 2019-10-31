//
//  MainTableViewController.m
//  005UITableView
//
//  Created by dfang on 2019-10-24.
//  Copyright © 2019年 east. All rights reserved.
//

#import "MainTableViewController.h"
#import "CarModel.h"
#import "CarGroupModel.h"
#import "CarTableViewCellXib.h"
#import "CarTableViewCell.h"
#import "DifferHeightModel.h"
#import "DifferHeightTableViewCell.h"

// 显示那种cell类型
typedef NS_ENUM(NSUInteger, CELLTYPE) {
    CELLCARGROUPS,
    CELLCARGROUPSXIB,
    CELLDIFFERS,
};

//// 在iOS6和Mac OS 10.8之前
//typedef enum : NSUInteger {
//    CELLCARGROUPS,
//    CELLCARGROUPSXIB,
//    CELLDIFFERS,
//} CELLTYPE;

@interface MainTableViewController ()

// 汽车分组数组
@property (nonatomic, strong) NSArray *carGroups;
// cell不同高数据数组
@property (nonatomic, strong) NSArray *differs;
// 显示cell类型，在viewDidLoad中更改为不同值加载不同cell
@property (nonatomic, assign) CELLTYPE cellType;

@end

@implementation MainTableViewController

// 懒加载初始化数据
- (NSArray *)carGroups {
    if (!_carGroups) {
        NSURL *carPlistURL = [[NSBundle mainBundle] URLForResource:@"cars" withExtension:@"plist"];
        NSArray *arrs = [NSArray arrayWithContentsOfURL:carPlistURL];
        NSMutableArray *groups = [NSMutableArray array];
        for (NSDictionary *dic in arrs) {
            CarGroupModel *carGroup = [CarGroupModel initWithDict:dic];
            [groups addObject:carGroup];
        }
        _carGroups = groups;
    }
    return _carGroups;
}

- (NSArray *)differs {
    if (_differs == nil) {
        NSString *differPath = [[NSBundle mainBundle] pathForResource:@"differheights" ofType:@"plist"];
        NSArray *arrs = [NSArray arrayWithContentsOfFile:differPath];
        NSMutableArray *differs = [NSMutableArray array];
        for (NSDictionary *dic in arrs) {
            DifferHeightModel *differ = [DifferHeightModel initWithDic:dic];
            [differs addObject:differ];
        }
        _differs = differs;
    }
    
    return _differs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // view和tableView指向同一个地址，view的实质就是tableView
//    NSLog(@"tableView:%p, view:%p", self.tableView, self.view);
//    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
//    redView.backgroundColor = [UIColor redColor];
//    [self.tableView addSubview:redView];
    
    // 设置分割线
//    self.tableView.separatorColor = UIColor.blueColor;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsZero;
    // 不显示默认分割线, 可在cell中自定义分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置加载cell类型，通过修改该值加载不同cell不同数据
    self.cellType = CELLDIFFERS;
    
    // 注册cell
    [self registerTableViewCell];
    
    // 设置预估高度可以避免heightForRowAtIndexPath开始的多次计算从而得到一定的优化
//    self.tableView.estimatedRowHeight = 250;
}

// 注册cell
- (void)registerTableViewCell {
    // 如果是从xib加载
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(CarTableViewCellXib.class) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:XIBREUSECELLID];
    // 注册
    [self.tableView registerClass:CarTableViewCell.class forCellReuseIdentifier:REUSECELLID];
    // 注册DifferHeightCell
    [self.tableView registerClass:DifferHeightTableViewCell.class forCellReuseIdentifier:DIFFERREUSECELLID];
}

#pragma mark - Tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    switch (self.cellType) {
        case CELLCARGROUPS:
        case CELLCARGROUPSXIB:
            count = self.carGroups.count;
            break;
        case CELLDIFFERS:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 1;
    switch (self.cellType) {
        case CELLCARGROUPS:
        case CELLCARGROUPSXIB:
        {
            CarGroupModel *carGroup = self.carGroups[section];
            count = carGroup.cars.count;
        }
            break;
        case CELLDIFFERS:
        {
            count = self.differs.count;
        }
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellType == CELLCARGROUPSXIB) {
        // xib创建cell
        CarTableViewCellXib *cell = [CarTableViewCellXib cellWithTableView:tableView];
        CarGroupModel *carGroup = self.carGroups[indexPath.section];
        CarModel *car = carGroup.cars[indexPath.row];
        cell.car = car;
        return cell;
    } else if (self.cellType == CELLCARGROUPS) {
        // 代码创建cell
        CarTableViewCell *cell = [CarTableViewCell cellWithTableView:tableView];
        CarGroupModel *carGroup = self.carGroups[indexPath.section];
        CarModel *car = carGroup.cars[indexPath.row];
        cell.car = car;
        return cell;
    } else {
        DifferHeightTableViewCell *cell = [DifferHeightTableViewCell cellWithTableview:tableView];
        DifferHeightModel *differModel = self.differs[indexPath.row];
        cell.differModel = differModel;
        return cell;
    }

//    // 显示为红色， backgroundView优先级高于backgroundColor
//    UIView *redView = [[UIView alloc] init];
//    redView.backgroundColor = UIColor.redColor;
//    cell.backgroundView = redView;
//    cell.backgroundColor = UIColor.blueColor;
//    // 显示为黄色，contentView
//    cell.contentView.backgroundColor = UIColor.yellowColor;
    
    // 将分割线间距设为0，也可设置tableView.separatorStyle = UITableViewCellSeparatorStyleNone;再自定义一个分割线
//    cell.separatorInset = UIEdgeInsetsZero;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.cellType == CELLDIFFERS) {
        return @"differs-header";
    }
    CarGroupModel *carGroup = self.carGroups[section];
    return carGroup.ID;
}

#pragma mark -- Tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 100;
    switch (self.cellType) {
        case CELLCARGROUPS:
        case CELLCARGROUPSXIB:
            height = 100;
            break;
        case CELLDIFFERS:
        {
            DifferHeightModel *differModel = self.differs[indexPath.row];
            height = differModel.cellHeight;
        }
            break;
        default:
            break;
    }
    return height;
}

// 设置预估高度，避免多次执行heightForRowAtIndexPath从而进行一定程度上的优化和设置tableView.estimatedRowHeight作用相同
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.cellType == CELLDIFFERS) {
        return nil;
    }
    UILabel *redLabel = [[UILabel alloc] init];
    redLabel.backgroundColor = UIColor.redColor;
    redLabel.textColor = UIColor.blueColor;
    
    CarGroupModel *carGroup = self.carGroups[section];
    redLabel.text = carGroup.brand;
    
    return redLabel;
}

@end

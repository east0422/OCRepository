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

@interface MainTableViewController ()

@property (nonatomic, strong) NSArray *carGroups;

@end

@implementation MainTableViewController

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
    
    // 如果是从xib加载
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(CarTableViewCellXib.class) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:REUSECELLXIBID];
    // 注册
    [self.tableView registerClass:CarTableViewCell.class forCellReuseIdentifier:REUSECELLID];
    
    self.tableView.rowHeight = 100;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.carGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CarGroupModel *carGroup = self.carGroups[section];
    return carGroup.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // xib创建cell
//    CarTableViewCellXib *cell = [CarTableViewCellXib cellWithTableView:tableView];
    // 代码创建cell
    CarTableViewCell *cell = [CarTableViewCell cellWithTableView:tableView];
    CarGroupModel *carGroup = self.carGroups[indexPath.section];
    CarModel *car = carGroup.cars[indexPath.row];
    cell.car = car;

//    // 显示为红色， backgroundView优先级高于backgroundColor
//    UIView *redView = [[UIView alloc] init];
//    redView.backgroundColor = UIColor.redColor;
//    cell.backgroundView = redView;
//    cell.backgroundColor = UIColor.blueColor;
//    // 显示为黄色，contentView
//    cell.contentView.backgroundColor = UIColor.yellowColor;
    
    // 将分割线间距设为0，也可设置tableView.separatorStyle = UITableViewCellSeparatorStyleNone;再自定义一个分割线
//    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CarGroupModel *carGroup = self.carGroups[section];
    return carGroup.ID;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *redLabel = [[UILabel alloc] init];
    redLabel.backgroundColor = UIColor.redColor;
    redLabel.textColor = UIColor.blueColor;
    
    CarGroupModel *carGroup = self.carGroups[section];
    redLabel.text = carGroup.brand;
    
    return redLabel;
}

@end

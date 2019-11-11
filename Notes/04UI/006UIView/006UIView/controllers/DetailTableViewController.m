//
//  DetailTableViewController.m
//  006UIView
//
//  Created by dfang on 2019-11-11.
//  Copyright © 2019年 east. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()

@property (nonatomic, strong) NSDictionary<NSString *, NSArray *> *alls;
@property (nonatomic, strong) NSArray *details;

@end

@implementation DetailTableViewController


- (NSDictionary<NSString *, NSArray *> *)alls {
    if (_alls == nil) {
        _alls = @{@"川菜": @[@"川味火锅", @"水煮鱼", @"回锅肉", @"麻婆豆腐", @"鱼香肉丝", @"水煮肉片", @"辣子鸡", @"酸菜鱼", @"宫保鸡丁", @"甜皮鸭"],
                     @"湘菜": @[@"组庵豆腐", @"组庵鱼翅", @"剁椒鱼头", @"辣椒炒肉", @"湘西外婆菜"],
                     @"粤菜": @[@"姜汁爆肉片", @"老婆饼", @"XO酱羊排", @"白切鸡"],
                     @"其它菜": @[@"大白菜炒豆皮", @"猪肉萝卜包子", @"蛋卷饼"],
                     };
    }
    return _alls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _category = self.alls.allKeys[0];
    self.details = self.alls[_category];
}

- (void)setCategory:(NSString *)category {
    _category = category;
    
    if ([self.alls.allKeys indexOfObject:self.category] == NSNotFound) {
        self.category = self.alls.allKeys[0];
    }
    self.details = self.alls[self.category];
    
    // 数据源重新加载
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailreuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"detailreuseIdentifier"];
    }
    
    cell.textLabel.text = self.details[indexPath.row];
    
    return cell;
}

@end

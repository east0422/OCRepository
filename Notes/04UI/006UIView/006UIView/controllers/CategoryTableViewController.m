//
//  CategoryTableViewController.m
//  006UIView
//
//  Created by dfang on 2019-11-11.
//  Copyright © 2019年 east. All rights reserved.
//

#import "CategoryTableViewController.h"

@interface CategoryTableViewController ()

@property (nonatomic, strong) NSArray *categories;

@end

@implementation CategoryTableViewController

- (NSArray *)categories {
    if (_categories == nil) {
        _categories = @[@"川菜", @"湘菜", @"粤菜", @"东北菜", @"鲁菜", @"浙菜", @"苏菜", @"清真菜", @"闽菜", @"沪菜", @"京菜", @"湖北菜", @"徽菜", @"豫菜", @"西北菜", @"云贵菜", @"江西菜", @"山西菜", @"广西菜", @"港台菜", @"其它菜"];
    }
    return _categories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryreuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"categoryreuseIdentifier"];
    }
    
    cell.textLabel.text = self.categories[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellClickCallback) {
        self.cellClickCallback(indexPath, self.categories[indexPath.row]);
    }
}

@end

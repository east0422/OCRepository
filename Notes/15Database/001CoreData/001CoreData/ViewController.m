//
//  ViewController.m
//  001CoreData
//
//  Created by dfang on 2020-5-28.
//  Copyright © 2020 east. All rights reserved.
//

#import "ViewController.h"
#import "Teacher+CoreDataProperties.h"
#import "AppDelegate.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *teachers;

@end

@implementation ViewController

- (NSMutableArray *)teachers {
    if (!_teachers) {
        AppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Teacher class])];
        // 查询条件
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"age > %d", 18];
        // 排序
        NSSortDescriptor *sortAge = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
        fetchRequest.sortDescriptors = @[sortAge];
        
        // 上下文发送查询请求
        NSError *error = nil;
        NSArray *arr = [appDelegate.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"获取教师数据失败：%@", error);
            _teachers = [NSMutableArray array];
        }
        _teachers = [NSMutableArray arrayWithArray:arr];
        
    }
    return _teachers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teachers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"teacherCellId";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    Teacher *teacher = [self.teachers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %lu", teacher.name, (unsigned long)teacher.tid];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"age:%lu, gender:%c",(unsigned long)teacher.age,(char)[teacher.gender integerValue]];
    
    return cell;
}

#pragma --- UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 对指定返回编辑类型处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
    
    Teacher *teacher = [self.teachers objectAtIndex:indexPath.row];
    [appDelegate.persistentContainer.viewContext deleteObject:teacher];
    NSError *error = nil;
    [appDelegate.persistentContainer.viewContext save:&error];
    if (error) {
        NSLog(@"删除%@失败：%@", teacher.name, error);
        return;
    }
    
    [self.teachers removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
}

@end

//
//  RootViewController.m
//  RuntimeArchived
//
//  Created by dfang on 2018-7-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import "RootViewController.h"
#import "Person.h"
#import "Teacher.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *archivedBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, 60, 50)];
    [archivedBtn setTitle:@"归档" forState:UIControlStateNormal];
    [archivedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [archivedBtn addTarget:self action:@selector(archivedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:archivedBtn];
    
    UIButton *unarchivedBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 60, 50)];
    [unarchivedBtn setTitle:@"解档" forState:UIControlStateNormal];
    [unarchivedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [unarchivedBtn addTarget:self action:@selector(unarchivedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:unarchivedBtn];
}

- (NSString *)archivedPath {
    NSString *temp = NSTemporaryDirectory();
    NSString *filePath = [temp stringByAppendingString:@"teacher.data"];
    return filePath;
}

- (void)archivedBtnClicked {
    Person *wang = [[Person alloc] init];
    wang.name = @"wife";
    wang.age = 27;
    wang.sex = Female;
    
    Teacher *teacherLiu = [[Teacher alloc] init];
    teacherLiu.name = @"liu";
    teacherLiu.age = 29;
    teacherLiu.sex = Male;
    teacherLiu.address = @"china";
    teacherLiu.email = @"123@163.com";
    teacherLiu.tel = @"123456";
    teacherLiu.spouse = wang;
 
    [NSKeyedArchiver archiveRootObject:teacherLiu toFile:[self archivedPath]];
}

- (void)unarchivedBtnClicked {
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivedPath]];
    NSLog(@"%@", teacher);
}

@end

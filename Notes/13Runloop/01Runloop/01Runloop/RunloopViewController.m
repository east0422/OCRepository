//
//  RunloopViewController.m
//  01Runloop
//
//  Created by dfang on 2018-10-26.
//  Copyright © 2018年 east. All rights reserved.
//

#import "RunloopViewController.h"

typedef BOOL(^RunloopBlock)(void);

@interface RunloopViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, assign) NSUInteger maximumTask;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];
    
    self.tasks = [NSMutableArray array];
    self.maximumTask = 15;
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (self.tasks.count == 0) {
//            return;
//        }
//        BOOL result = NO;
//        while (result == NO && self.tasks.count) {
//            RunloopBlock runloopBlock = self.tasks.firstObject;
//            result = runloopBlock();
//            [self.tasks removeObjectAtIndex:0];
//        }
//    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        // do nothing, just make current runloop execute every 0.01
    }];
    [self addRunloopObserver];
}

// 初始化tableview
- (UITableView *)tableview {
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        // 不显示分割线
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.rowHeight = 150;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"noncellid"];
    }
    return _tableview;
}

// datasource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 400;
}

// datasource method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noncellid"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noncellid"];
    }
    // 因为contentview内容每次都是添加的，所以复用中的子视图需要删除
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self addLabel:cell indexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    [self addRunloopTask:^BOOL{
        [weakSelf addImage:cell forIndex:0];
        return YES;
    }];
    [self addRunloopTask:^BOOL{
        [weakSelf addImage:cell forIndex:1];
        return YES;
    }];
    [self addRunloopTask:^BOOL{
        [weakSelf addImage:cell forIndex:2];
        return YES;
    }];
    
    return cell;
}

// 添加文字标签
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

// 添加图片
- (void)addImage:(UITableViewCell *)cell forIndex   :(NSUInteger)index {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(5 + 100 * index, 30, 85, 85);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [UIView transitionWithView:cell.contentView duration:0.03 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
}

// 添加runloop代码块
- (void)addRunloopTask:(RunloopBlock)task {
    [self.tasks addObject:task];
    if (self.tasks.count > self.maximumTask) {
        [self.tasks removeObjectAtIndex:0];
    }
}

// 监听runloop在指定时刻执行
void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    RunloopViewController *vc = (__bridge RunloopViewController *)(info);
    if (vc.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && vc.tasks.count) {
        RunloopBlock runloopBlock = vc.tasks.firstObject;
        result = runloopBlock();
        [vc.tasks removeObjectAtIndex:0];
    }
}

// 添加runloop观察者
- (void)addRunloopObserver {
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        NULL,
        NULL,
        NULL,
    };
    
    CFRunLoopObserverRef observerRef = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &runLoopObserverCallBack, &context);
    // kCFRunLoopDefaultMode 滚动结束才开始渲染，kCFRunLoopCommonModes滚动是也渲染
    CFRunLoopAddObserver(runloopRef, observerRef, kCFRunLoopCommonModes);
    CFRelease(observerRef);
}

@end

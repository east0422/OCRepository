//
//  DownloadImageViewController.m
//  003NSOperation
//
//  Created by dfang on 2019-11-22.
//  Copyright © 2019 east. All rights reserved.
//

#import "DownloadImageViewController.h"
#import "AppInfo.h"

@interface DownloadImageViewController () <UITableViewDataSource, UITableViewDelegate>

/** 应用信息数组 */
@property (nonatomic, strong) NSArray *appinfos;
/** 表视图 */
@property (nonatomic, strong) UITableView *tableView;

/** 操作队列，用于下载网络图片 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;
/** 下载操作字典(key为图片，value为对应的下载操作) */
@property (nonatomic, strong) NSMutableDictionary *downOperations;
/** 下载图片缓存 */
@property (nonatomic, strong) NSMutableDictionary *imageCaches;

@end

@implementation DownloadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除缓存
    [self.imageCaches removeAllObjects];
    [self.downOperations removeAllObjects];
    
    // 取消队列中所有操作
    [self.operationQueue cancelAllOperations];
}

// 懒加载
- (NSArray *)appinfos {
    if (_appinfos == nil) {
        NSURL *appURL = [[NSBundle mainBundle] URLForResource:@"apps" withExtension:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfURL:appURL];
        
        NSMutableArray *apps = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            [apps addObject:[AppInfo initWithDic:dic]];
        }
        _appinfos = apps;
    }
    return _appinfos;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.backgroundColor = UIColor.lightGrayColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        // 设置最大并发数，同时最多支持任务数
        _operationQueue.maxConcurrentOperationCount = 5;
    }
    return _operationQueue;
}

- (NSMutableDictionary *)downOperations {
    if (_downOperations == nil) {
        _downOperations = [NSMutableDictionary dictionary];
    }
    return _downOperations;
}

- (NSMutableDictionary *)imageCaches {
    if (_imageCaches == nil) {
        _imageCaches = [NSMutableDictionary dictionary];
    }
    return _imageCaches;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appinfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        // UITableViewCellStyleValue1
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cellid"];
    }
    
    AppInfo *appInfo = self.appinfos[indexPath.row];
    cell.textLabel.text = appInfo.name;
    cell.detailTextLabel.text = appInfo.download;
    
    if ([self.imageCaches valueForKey:appInfo.icon]) { // 有对应的图片缓存
        cell.imageView.image = [self.imageCaches valueForKey:appInfo.icon];
//        NSLog(@"本地有图片缓存！");
    } else {
        [self downloadImageForIndexPath:indexPath];
    }
    
    return cell;
}

- (void)downloadImageForIndexPath:(NSIndexPath *)indexPath {
    AppInfo *appInfo = self.appinfos[indexPath.row];
    if ([self.downOperations valueForKey:appInfo.icon]) {
        NSLog(@"正在下载中，请稍后......");
        return;
    }
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
         NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:appInfo.icon]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (image) {
            [self.imageCaches setValue:image forKey:appInfo.icon];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // 在主队列中更新
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            }];
        }
    }];
    
    [self.downOperations setValue:operation forKey:appInfo.icon];
    
    [self.operationQueue addOperation:operation];
}

@end

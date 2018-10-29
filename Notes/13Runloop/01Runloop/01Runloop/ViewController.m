//
//  ViewController.m
//  01Runloop
//
//  Created by dfang on 2018-10-23.
//  Copyright © 2018年 east. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自动加到NSDefaultRunLoopMode模式的runloop中, 有UI滚动等操作会暂不执行selector
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:self repeats:YES];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    // NSDefaultRunLoopMode 时钟、网络事件
    // NSRunLoopCommonModes 用户交互(UI事件)
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

// update time value
- (void)updateTime {
    static int time = 0;
    time++;
    // 若使用NSRunLoopCommonModes中有耗时操作则会引起UI界面的卡顿
//    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"%@ %d", [NSThread currentThread], time);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

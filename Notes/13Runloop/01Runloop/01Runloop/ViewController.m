//
//  ViewController.m
//  01Runloop
//
//  Created by dfang on 2018-10-23.
//  Copyright © 2018年 east. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self timerDemo];
    [self gcdDemo];
}

- (void)timerDemo {
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
    NSLog(@"%@ %@ %d", [NSThread currentThread], [NSRunLoop currentRunLoop], time);
}

- (void)gcdDemo {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0); // dispatch_get_main_queue();
    // timer定义为局部变量的话该方法执行完成会销毁
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = DISPATCH_TIME_NOW;
    dispatch_time_t interval = 1.0 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        [self updateTime];
    });
    dispatch_resume(self.timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  001NSThread
//
//  Created by dfang on 2019-11-21.
//  Copyright © 2019 east. All rights reserved.
//

#import "ViewController.h"
#include <pthread.h>

@interface ViewController ()

/** 票数 */
@property (nonatomic, assign) NSInteger tickets;

/** 条件 */
@property (nonatomic, strong) NSCondition *ticketsCondition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"start----- %@", [NSThread currentThread]);

//    [self pthreadDemo];
    
//    [self nsthreadDemo];
    
    self.tickets = 20;
    self.ticketsCondition = [[NSCondition alloc] init];
    [self saleTicketsDemo];
    
    // 注意输出end位置
    NSLog(@"end------ %@", [NSThread currentThread]);
}

void *pthreadRun(void *params) {
    NSLog(@"------ curthread: %@", [NSThread currentThread]); // 新的子线程
    printf("------params: %s\n", (char *)params);
    return NULL;
}

/** pthread使用 */
- (void)pthreadDemo {
    pthread_t tid;
    pthread_attr_t *attr = NULL;
    /**
     pthread_create方法参数
     第一个：指向新线程标识符的指针
     第二个：用于设置新线程的属性。传递NULL表示设置为默认线程属性
     第三个：指定新线程将运行的函数起始地址
     第四个：指定新线程将运行的参数。
     返回值：成功返回0，失败返回错误号
     */
    // attr如果设置为PTHREAD_CREATE_DETACHED，则新线程不能用pthread_join()来同步，且在退出时自行释放所占用的资源。缺省为PTHREAD_CREATE_JOINABLE状态
    int createR = pthread_create(&tid, attr, pthreadRun, "pthreaddemo--aaa");
    if (createR == 0) {
//        NSLog(@"pthread create success: %@", [NSThread currentThread]);
        
        // 当调用pthread_join时，当前线程会处于阻塞状态，直到被调用的线程结束后，当前线程才会重新开始执行。当pthread_join函数返回后，被调用线程才算真正意义上的结束，它的内存空间也会被释放(如果被调用线程时非分离的)。注意
        // 1. 被释放的内存空间仅仅是系统空间，你必须手动清除程序分配的空间(比如malloc分配的空间)
        // 2. 一个线程只能被一个线程所连接
        // 3. 被连接的线程必须是非分离的，否则连接会出错
//        int joinR = pthread_join(tid, NULL);
//        if (joinR == 0) {
//            NSLog(@"pthread join success %@", [NSThread currentThread]);
//        } else {
//            NSLog(@"pthread join fail: %s", strerror(joinR));
//        }
        
        // 设置子线程的状态为detached则该线程运行结束后会自动释放所有资源
//        pthread_detach(tid);
    } else {
        NSLog(@"pthread create fail: %s", strerror(createR));
    }
}

- (void)nsthreadRunWith:(id)obj {
    for (int i = 0 ; i < 10; i++) {
        NSLog(@"%d, %@, %@", i, obj, [NSThread currentThread]);
    }
}

/** NSThread使用 */
- (void)nsthreadDemo {
    // 主线程中长时间运行会阻塞主线程(直到运行完毕)，可能会造成ui界面上操作卡顿
//    [self nsthreadRunWith:@"test"];
    
    // 1. 创建一个子线程在子线程中运行
//    [self performSelectorInBackground:@selector(nsthreadRunWith:) withObject:@"thread1"];
    
    // 2. 手动创建一个子线程并启动
//    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(nsthreadRunWith:) object:@"thread2"];
//    thread2.name = @"thread2";
    // 线程优先级。是一个浮点数，0.0～1.0，默认值 0.5。开发时一般不修改优先级的值。优先级，调用很多次的时候，才能体现出来。
//    thread2.threadPriority = 0.2;
//    [thread2 start];
    
    // 3. 直接创建并启动子线程
//    [NSThread detachNewThreadSelector:@selector(nsthreadRunWith:) toTarget:self withObject:@"thread3"];
    
    // 4. 线程阻塞和终止
    NSThread *thread4 = [[NSThread alloc] initWithBlock:^{
        for (int i = 0; i < 20; i++) {
            // 满足某一个条件以后，阻塞线程的执行。 也就是让线程休息一会
            if (i == 10) {
                [NSThread sleepForTimeInterval:3.0];
            }
            // 一旦达到某一个条件，就强制终止线程的执行
            if (i == 15) {
                // 一旦强制终止，就在不能重新启动
                // 一旦强制终止，后面的代码都不会执行
                [NSThread exit];
            }
            NSLog(@"%@--- %d", [NSThread currentThread], i);
        }
        // 因为线程终止，该语句永远不会执行
        NSLog(@"线程结束");
    }];
    thread4.name = @"thread4";
    [thread4 start];
    
    
}

/**
 售票使用加锁，互斥锁等
 加锁，锁定的代码尽量少。
 加锁范围内的代码， 同一时间只允许一个线程执行
 互斥锁的参数:任何继承 NSObject *对象都可以。
 要保证这个锁，所有的线程都能访问到, 而且是所有线程访问的是同一个锁对象 */
- (void)saleTickets {
    while (true) {
        // 使用条件，还可以使用其他@synchronized、mutex等
        [self.ticketsCondition lock];
        if (self.tickets > 0) {
            // 模拟买票延时
//            sleep(0.3);
            [NSThread sleepForTimeInterval:0.3];
            self.tickets--;
            NSLog(@"剩余票数：%ld, %@", (long)self.tickets, [NSThread currentThread]);
        } else {
            NSLog(@"票卖完了！");
            break;
        }
        [self.ticketsCondition unlock];
    }
    NSLog(@"退出saleTickets");
}

/** nsthread售票演示 */
- (void)saleTicketsDemo {
    NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    threadA.name = @"售票员A";
    [threadA start];
   
    NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    threadB.name = @"售票员B";
    [threadB start];
    
    NSThread *threadC = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    threadC.name = @"售票员C";
    [threadC start];
}

@end

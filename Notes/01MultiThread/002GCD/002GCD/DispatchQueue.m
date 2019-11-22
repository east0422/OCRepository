//
//  DispatchQueue.m
//  002GCD
//
//  Created by dfang on 2019-11-21.
//  Copyright © 2019 east. All rights reserved.
//

#import "DispatchQueue.h"

@implementation DispatchQueue

- (void)printHello {
    NSLog(@"Hello world!");
}

/**
 串行队列：一个一个执行
 异步执行：肯定会开新线程，在新线程执行
 结果：只会开一个线程，而且所有任务都在这个新的线程里面执行
*/
- (void)testSerialQueueWithAsync {
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueueWithAsync", DISPATCH_QUEUE_SERIAL);
    NSLog(@"------testSerialQueueWithAsync start in thread:%@", [NSThread currentThread]);
    for (int i = 0; i < 10; i++) {
        dispatch_async(serialQueue, ^{
            NSLog(@"i:%d, cur thread: %@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"------testSerialQueueWithAsync end in thread:%@", [NSThread currentThread]);
}

/**
 并发队列：可以同时执行多个任务
 异步执行：会开新线程，在新线程执行
 结果：会开很多个线程，同时执行
*/
- (void)testConcurrentQueueWithAsync {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueueWithAsync", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"------testConcurrentQueueWithAsync start in thread:%@", [NSThread currentThread]);
    for (int i = 10; i < 20; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"i:%d, cur thread: %@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"------testConcurrentQueueWithAsync end in thread:%@", [NSThread currentThread]);
}

/**
 主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程.
 异步执行： 会开新线程，在新线程执行
 结果: 不开线程， 只能在主线程上面，顺序执行!
 */
- (void)testMainQueueWithAsync {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"------testMainQueueWithAsync start in thread:%@", [NSThread currentThread]);
    for (int i = 20; i < 30; i++) {
        dispatch_async(mainQueue, ^{
            NSLog(@"i:%d, cur thread: %@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"------testMainQueueWithAsync end in thread:%@", [NSThread currentThread]);
}

/**
 全局队列跟并发队列的区别
 1. 全局队列没有名称 并发队列有名称
 2. 全局队列，是供所有的应用程序共享。
 3. 在MRC开发，并发队列，创建完了，需要释放。 全局队列不需要我们管理
*/
- (void)testGlobalQueueWithAsync {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    NSLog(@"------testGlobalQueueWithAsync start in thread:%@", [NSThread currentThread]);
    for (int i = 30; i < 40; i++) {
        dispatch_async(globalQueue, ^{
            NSLog(@"i:%d, cur thread: %@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"------testGlobalQueueWithAsync end in thread:%@", [NSThread currentThread]);
}

/**
 串行队列：顺序，一个一个执行
 同步任务：不会开辟新线程，是在当前线程执行
 结果：不开新线程，在当前线程顺序执行
*/
- (void)testSerialQueueWithSync {
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueueWithSync", DISPATCH_QUEUE_SERIAL);
    NSLog(@"------testSerialQueueWithSync start in thread:%@", [NSThread currentThread]);
    for (int i = 20; i < 30; i++) {
        dispatch_sync(serialQueue, ^{
            NSLog(@"i: %d, cur thread: %@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"------testSerialQueueWithSync end in thread:%@", [NSThread currentThread]);
}

/**
 并发队列：可以同时执行多个任务
 同步任务：不会开辟新线程，是在当前线程执行
 结果：不开新线程，顺序一个一个执行。
*/
- (void)testConcurrentQueueWithSync {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueueWithSync", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"------testConcurrentQueueWithSync start in thread:%@", [NSThread currentThread]);
    for (int i = 30; i < 40; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"i:%d, cur thread: %@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"------testConcurrentQueueWithSync end in thread:%@", [NSThread currentThread]);
}

/**
 主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程.
 同步执行：要马上执行
 结果：死锁
*/
- (void)testMainQueueWithSync {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"------testMainQueueWithSync start in thread:%@", [NSThread currentThread]);
    dispatch_sync(mainQueue, ^{ // 阻塞主线程，死锁，会崩溃
        NSLog(@"cur thread: %@", [NSThread currentThread]);
    });
    NSLog(@"------testMainQueueWithSync end in thread:%@", [NSThread currentThread]);
}

- (void)testGlobalQueueWithSync {
    // 每次获取的global都不一定是上一个
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"------testGlobalQueueWithSync start in thread:%@", [NSThread currentThread]);
    for (int i = 50; i < 60; i++) {
        dispatch_sync(globalQueue, ^{
            NSLog(@"i:%d, cur thread: %@", i, [NSThread currentThread]);
        });
    }
    NSLog(@"------testGlobalQueueWithSync end in thread:%@", [NSThread currentThread]);
}

- (void)testConcurrentQueueWithBarrierAsync {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueueWithBarrierAsync", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"------testConcurrentQueueWithBarrierAsync start in thread:%@", [NSThread currentThread]);
    for (int i = 100; i < 110; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"i=%d", i);
        });
    }
    for (int i = 1000; i < 1010; i++) {
        dispatch_barrier_async(concurrentQueue, ^{
            NSLog(@"barrier async i=%d", i);
            if (i == 1009) {
                NSLog(@"barrier async finished");
                NSLog(@"current thread is : %@", [NSThread currentThread]);
            }
        });
    }
    NSLog(@"------testConcurrentQueueWithBarrierAsync-------");
    
    for (int i = 110; i < 120; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"i=%d",i);
        });
    }
    NSLog(@"------testConcurrentQueueWithBarrierAsync end in thread:%@", [NSThread currentThread]);
}

- (void)testConcurrentQueueWithBarrierSync {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueueWithBarrierSync", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"------testConcurrentQueueWithBarrierSync start in thread:%@", [NSThread currentThread]);
    for (int i = 200; i < 210; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"i=%d", i);
        });
    }
    for (int i = 2000; i < 2010; i++) {
        dispatch_barrier_sync(concurrentQueue, ^{
            NSLog(@"barrier sync i=%d", i);
            if (i == 2009) {
                NSLog(@"barrier sync finished");
                NSLog(@"current thread is : %@", [NSThread currentThread]);
            }
        });
    }
    NSLog(@"------testConcurrentQueueWithBarrierSync-------");
    
    for (int i = 210; i < 220; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"i=%d",i);
        });
    }
    NSLog(@"------testConcurrentQueueWithBarrierSync end in thread:%@", [NSThread currentThread]);
}

- (void)testConcurrentWithMix {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentwithmix", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"正在登录: %@", [NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"处理事件一：%@", [NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        sleep(1.0);// 模拟耗时事件
        NSLog(@"处理事件二：%@", [NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"处理事件三：%@", [NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"处理事件四：%@", [NSThread currentThread]);
    });
}

- (void)testMutableDictionaryThreadSafe {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dispatch_async(concurrentQueue, ^{
        for (int i = 0; i < 100; i++) {
            dict[@(i)] = @(i);
        }
        dispatch_semaphore_signal(sema);
    });
    
    // 如果放到下面dispatch_async后面会导致运行崩溃，因为NSMutableDictionary不是线程安全的，任意一个线程在往字典里写入数据的时候是不允许有其它线程访问的，不管是读或写都不可以
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_async(concurrentQueue, ^{
        for (int i = 0; i < 100; i++) {
            dict[@(i)] = @(0);
        }
        dispatch_semaphore_signal(sema);
    });
    //    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    NSLog(@"dict is: %@", dict);
}

- (void)testDispatchOnce {
    NSLog(@"testDispatchOnce----start");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ // 只执行一次，后续不会再执行
        NSLog(@"dispatch once--------%ld", onceToken);
    });
    NSLog(@"testDispatchOnce----end");
}

- (void)testDispatchGroup {
    // 创建一个调度组
    dispatch_group_t group = dispatch_group_create();
    // 获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 任务添加到队列组中
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载一 -------%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        sleep(1.5);
        NSLog(@"下载二 -------%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载三 -------%@", [NSThread currentThread]);
    });
    
    // 获得所有调度组队列里面任务完成的通知
    dispatch_group_notify(group, queue, ^{
        sleep(1.0);
        NSLog(@"所有下载都完成了-----%@", [NSThread currentThread]);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有下载都完成了，在主队列里处理后续事情-----%@", [NSThread currentThread]);
    });
}

- (void)testDispatchDelay {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
//    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"testDispatchDelay -----");
    dispatch_after(when, queue, ^{ // when 表示从现在开始，经过多少纳秒以后
        NSLog(@"延迟了一会儿------%@", [NSThread currentThread]);
    });
}

@end

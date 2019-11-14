//
//  DispatchQueue.m
//  001GCD
//
//  Created by dfang on 2019-11-13.
//  Copyright © 2019年 east. All rights reserved.
//

#import "DispatchQueue.h"

void printHello() {
    NSLog(@"Hello world!");
}

void testSerialQueueWithAsync () {
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueueWithAsync", DISPATCH_QUEUE_SERIAL);
    NSLog(@"------testSerialQueueWithAsync start in thread:%@", [NSThread currentThread]);
    for (int i = 0; i < 10; i++) {
        dispatch_async(serialQueue, ^{
            NSLog(@"i=%d", i);
            NSLog(@"cur thread: %@", [NSThread currentThread]);
        });
    }
    NSLog(@"------testSerialQueueWithAsync end in thread:%@", [NSThread currentThread]);
}

void testConcurrentQueueWithAsync () {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueueWithAsync", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"------testConcurrentQueueWithAsync start in thread:%@", [NSThread currentThread]);
    for (int i = 10; i < 20; i++) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"i=%d", i);
            NSLog(@"cur thread: %@", [NSThread currentThread]);
        });
    }
    NSLog(@"------testConcurrentQueueWithAsync end in thread:%@", [NSThread currentThread]);
}

void testSerialQueueWithSync () {
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueueWithSync", DISPATCH_QUEUE_SERIAL);
    NSLog(@"------testSerialQueueWithSync start in thread:%@", [NSThread currentThread]);
    for (int i = 20; i < 30; i++) {
        dispatch_sync(serialQueue, ^{
            NSLog(@"i=%d", i);
            NSLog(@"cur thread: %@", [NSThread currentThread]);
        });
    }
    NSLog(@"------testSerialQueueWithSync end in thread:%@", [NSThread currentThread]);
}

void testConcurrentQueueWithSync () {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueueWithSync", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"------testConcurrentQueueWithSync start in thread:%@", [NSThread currentThread]);
    for (int i = 30; i < 40; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"i=%d", i);
            NSLog(@"cur thread: %@", [NSThread currentThread]);
        });
    }
    NSLog(@"------testConcurrentQueueWithSync end in thread:%@", [NSThread currentThread]);
}

void testConcurrentQueueWithBarrierAsync () {
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

void testConcurrentQueueWithBarrierSync () {
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

void testMutableDictionaryThreadSafe () {
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

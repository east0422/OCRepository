//
//  ThreadLock.m
//  004ThreadSafe
//
//  Created by dfang on 2020-5-23.
//  Copyright © 2020 east. All rights reserved.
//

#import "ThreadLock.h"
#import <os/lock.h>
#import <pthread.h>

@implementation ThreadLock

- (void)printTest {
    NSLog(@"%@ start in %@", NSStringFromSelector(_cmd), [NSThread currentThread]);
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"%@ end in %@", NSStringFromSelector(_cmd), [NSThread currentThread]);
}

/** nonatomic崩溃，set方法没有加锁。atomic最终atomicStr值不确定(非线程安全)，但是不会崩溃*/
- (void)testAtomic {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(100, queue, ^(size_t index) {
        // 崩溃。nonatomic属性在set时是没有加锁的，而内部实现是先释放旧的然后retain新的，最后将新的赋给旧的，在某一时刻一个线程访问到的是另一线程刚release的
//        self.nonatomicStr = [NSString stringWithFormat:@"nonatomicstr-%ld", index];
        self.atomicStr = [NSString stringWithFormat:@"atomicstr-%ld", index];
    });
    NSLog(@"atomStr is: %@", self.atomicStr);
}

/** 不加nslock结果值不一定是10000 */
- (void)testNSLock {
    self.num = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLock *lock = [NSLock new];
    dispatch_apply(10000, queue, ^(size_t index) {
        [lock lock];
//        self.num = index;
        self.num++;
        [lock unlock];
    });
    NSLog(@"num is: %ld", (long)self.num);
}

/** 互斥锁影响性能 */
- (void)testSynchronized {
    NSObject *obj = [NSObject new];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        @synchronized (obj) {
            [self printTest];
        }
    });

    dispatch_async(queue, ^{
        @synchronized (obj) {
            [self printTest];
        }
    });
}

/** 比较常用，性能相对比较高 */
- (void)testSemaphore {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 传入的参数必须大于或者等于0，否则会返回NULL
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    // 返回0表示成功不需要等待直接执行后续代码，非0需要等待信号或超时才能执行后续代码。
    // 信号量值减1，若返回值小于0则等待信号量或超时。
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self printTest];
        // 返回0表示没有线程需要其处理的信号量(即没有需要唤醒的线程)。\
            非0表示有一个或多个线程需要唤醒，则唤醒一个线程(若线程有优先级，则唤醒优先级最高的线程，否则随机唤醒一个线程）
        // 信号量加1。
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self printTest];
        dispatch_semaphore_signal(semaphore);
    });
}

/** 需引入os/lock.h头文件 */
- (void)testOSUnfairLock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
    dispatch_apply(3, queue, ^(size_t index) {
        os_unfair_lock_lock(&lock);
        [self printTest];
        os_unfair_lock_unlock(&lock);
    });
}

/** 在pthread.h头文件中 */
- (void)testPthreadMutex {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    dispatch_apply(3, queue, ^(size_t index) {
        pthread_mutex_lock(&mutex);
        [self printTest];
        pthread_mutex_unlock(&mutex);
    });
}

/** 还有wait/signal等方法 */
- (void)testNSCondition {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSCondition *condition = [NSCondition new];
    dispatch_apply(3, queue, ^(size_t index) {
        [condition lock];
        [self printTest];
        [condition unlock];
    });
}

/** 还有lockWhenCondition:/unlockWithCondition:等方法 */
- (void)testNSConditionLock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSConditionLock *conditionLock = [NSConditionLock new];
    dispatch_apply(3, queue, ^(size_t index) {
        [conditionLock lock];
        [self printTest];
        [conditionLock unlock];
    });
}

@end

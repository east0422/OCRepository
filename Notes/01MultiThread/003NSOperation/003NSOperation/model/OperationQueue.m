//
//  OperationQueue.m
//  003NSOperation
//
//  Created by dfang on 2019-11-22.
//  Copyright © 2019 east. All rights reserved.
//

#import "OperationQueue.h"

@interface OperationQueue ()

/** 操作队列 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation OperationQueue

/** 懒加载操作队列 */
- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (void)cancelAll {
    // 取消队列的所有操作会把任务从队列中全部删除
    [self.operationQueue cancelAllOperations];
    NSLog(@"取消所有操作");
    
    // 取消挂起状态(suspended为NO时执行任务，为YES时暂停任务)，取消队列操作将队列置于启动状态以便队列的继续
    self.operationQueue.suspended = NO;
}

- (void)pause {
    if (self.operationQueue.operationCount > 0) {
        self.operationQueue.suspended = YES;
    } else {
        NSLog(@"没有任务");
    }
}

- (void)testDependency {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2.0);
        NSLog(@"下载------%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(1.0);
        NSLog(@"解压------%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"通知用户------%@", [NSThread currentThread]);
    }];
    
    // op2依赖op1
    [op2 addDependency:op1];
    // op3依赖op2
    [op3 addDependency:op2];
    
    // 将op1和op2加入到自定义操作队列operationQueue中，waitUntilFinished为YES等待操作执行结束再执行后面的
    [self.operationQueue addOperations:@[op1, op2] waitUntilFinished:NO];
    // 将op3加入到主队列中，依据需要将判断操作是否需要加到主队列中进行处理
    [[NSOperationQueue mainQueue] addOperation:op3];
    NSLog(@"收到了！");
}

- (void)testMaxConcurrentCount {
    // 设置最大并发操作数(最大并发数不是线程的数量而是同时执行的操作数量)
//    self.operationQueue.maxConcurrentOperationCount = 3;
    
    for(int i = 0; i < 10; i++) {
        [self.operationQueue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"%d ------ %@", i, [NSThread currentThread]);
        }];
    }
}

- (void)testBlockInMain {
    [self.operationQueue addOperationWithBlock:^{
        sleep(1.0);
        NSLog(@"耗时操作----- %@", [NSThread currentThread]);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"主队列中执行操作------ %@", [NSThread currentThread]);
        }];
    }];
}

- (void)testBlockWithMultipleTask {
    // 1.创建操作对象
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    // 2.添加任务
    [operation addExecutionBlock:^{
        NSLog(@"下载一 ---- %@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"下载二 ---- %@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"下载三 ---- %@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"下载四 ---- %@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"下载五 ---- %@", [NSThread currentThread]);
    }];
    // 3.执行任务(同步执行任务几乎不用；没有规律)
    [operation start];
}

- (void)testBlock {
    for (int i = 0; i < 10; i++) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"111 下载 %d ----- %@", i, [NSThread currentThread]);
        }];
        
        [op addExecutionBlock:^{
            NSLog(@"1111 ---- %@", [NSThread currentThread]);
        }];
        // 如果操作任务大于1就会开辟多条线程执行，等于1时只会在当前线程执行
//        [op start];
        
//         将操作加到操作队列会自动异步(创建子线程在子线程中)执行
        [self.operationQueue addOperation:op];
        
        // 简化版
//        [self.operationQueue addOperationWithBlock:^{
//            NSLog(@"下载 %d ----- %@", i, [NSThread currentThread]);
//        }];
    }
}

- (void)invocationRun:(id)obj {
    NSLog(@"invocationRun %@ ---- %@", obj, [NSThread currentThread]);
}

- (void)testInvocation {
    for (int i = 0; i < 10; i++) {
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationRun:) object:@(i)];
        // 会立即在当前线程执行
//        [op start];
        // 将操作加到操作队列会自动异步执行
        [self.operationQueue addOperation:op];
    }
}

@end

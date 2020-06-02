//
//  main.m
//  004ThreadSafe
//
//  Created by dfang on 2020-5-23.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadLock.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        NSLog(@"Hello, World!");
        ThreadLock *tlock = [[ThreadLock alloc] init];
        
//        [tlock testAtomic];
//        [tlock testNSLock];
//        [tlock testSynchronized];
//        [tlock testSemaphore];
//        [tlock testOSUnfairLock];
//        [tlock testPthreadMutex];
//        [tlock testNSCondition];
        [tlock testNSConditionLock];
        
        // 确保异步队列开启子线程未执行完毕而主线程已执行完毕
        [NSThread sleepForTimeInterval:3];
    }
    return 0;
}

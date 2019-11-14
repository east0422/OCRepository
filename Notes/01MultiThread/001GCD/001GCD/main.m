//
//  main.m
//  001GCD
//
//  Created by dfang on 2019-11-13.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DispatchQueue.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

//        printHello();
        
//        testSerialQueueWithAsync();
        
//        testConcurrentQueueWithAsync();
        
//        testSerialQueueWithSync();
        
//        testConcurrentQueueWithSync();
        
//        testConcurrentQueueWithBarrierAsync();
        
//        testConcurrentQueueWithBarrierSync();
        
        testMutableDictionaryThreadSafe();
        
        // 暂停3秒，使得队列能执行完成
        [NSThread sleepForTimeInterval:3];
    }
    return 0;
}

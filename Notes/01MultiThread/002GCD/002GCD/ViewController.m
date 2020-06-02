//
//  ViewController.m
//  002GCD
//
//  Created by dfang on 2019-11-21.
//  Copyright © 2019 east. All rights reserved.
//

#import "ViewController.h"
#import "DispatchQueue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     [self testDispatchQueue];
}

- (void)testDispatchQueue {
    DispatchQueue *dq = [[DispatchQueue alloc] init];
//    [dq printHello];
    
//    [dq testNested];
//    [dq testSerialQueueWithAsync];
//    [dq testConcurrentQueueWithAsync];
//    [dq testMainQueueWithAsync];
//    [dq testGlobalQueueWithAsync];
    
//    [dq testSerialQueueWithSync];
//    [dq testConcurrentQueueWithSync];
//    [dq testMainQueueWithSync];
//    [dq testGlobalQueueWithSync];

//    [dq testConcurrentQueueWithBarrierAsync];
//    [dq testConcurrentQueueWithBarrierSync];
    
//    [dq testConcurrentWithMix];
    
//    [dq testMutableDictionaryThreadSafe];
    
//    [dq testDispatchOnce];
//    [dq testDispatchOnce];
    
//    [dq testDispatchGroup];
    
//    [dq testDispatchDelay];
    
//    [dq testDispatchApplyConcurrent];
    
    [dq testDispatchApplySerial];
    
    // 暂停3秒，使得队列能执行完成
    [NSThread sleepForTimeInterval:3];
}

@end

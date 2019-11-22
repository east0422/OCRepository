//
//  ViewController.m
//  003NSOperation
//
//  Created by dfang on 2019-11-21.
//  Copyright © 2019 east. All rights reserved.
//

#import "ViewController.h"
#import "OperationQueue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self operationDemo];
}

- (void)operationDemo {
    OperationQueue *oq = [[OperationQueue alloc] init];
    
//    [oq testDependency];
    
//    [oq testMaxConcurrentCount];

//    [oq testBlockInMain];

//    [oq testBlockWithMultipleTask];
    
//    [oq testBlock];

    [oq testInvocation];
}

@end

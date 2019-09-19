//
//  ViewController.m
//  003RAC
//
//  Created by dfang on 2019-9-4.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ViewController.h"
#import "RedView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/NSObject+RACKVOWrapper.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RedView *redView;

// 用于保存subscriber
@property (nonatomic, strong) id<RACSubscriber> subscriber;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // notification
//    [self testNotification];
    
    // block
//    [self testBlock];
    
    // rac
//    [self testRACMethod];
    
    //rac-kvo
//    [self testRACKVO];
    
    // rac
//    [self testRACProperty];
    
    // rac signal
//    [self testRACSignal];
    
    // rac subject
    [self testRACSubject];
}

- (void)testNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"redview" object:nil queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      NSLog(@"note:%@", note.object);
                                                      NSString *newTitle = [NSString stringWithFormat:@"哈哈%d", (arc4random() % 100)];
                                                      [(UIButton *)note.object setTitle:newTitle forState:UIControlStateNormal];;
                                                  }];
}

- (void)dealloc
{
    // 删除所有
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testBlock {
    self.redView.btnClickedblock = ^(id _Nonnull btn) {
        NSLog(@"RedView btnClicked:%@", btn);
        NSString *newTitle = [NSString stringWithFormat:@"哈哈%d", (arc4random() % 100)];
        [(UIButton *)btn setTitle:newTitle forState:UIControlStateNormal];
    };
}

- (void)testRACMethod {
    // 直接监听redview中btn点击事件
    [[self.redView.btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"aaa x:%@", x);
        if ([x isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)x;
            NSString *newTitle = [NSString stringWithFormat:@"哈哈%d", (arc4random() % 100)];
            [btn setTitle:newTitle forState:UIControlStateNormal];
        }
    }];
    
    // 监听redview中btnClicked方法执行
//    [[self.redView rac_signalForSelector:@selector(btnClicked:)] subscribeNext:^(RACTuple * _Nullable x) {
//        NSLog(@"RedView btnClicked x:%@", x);
//
//        NSArray *views = x.allObjects;
//        for (UIView *view in views) { // 遍历所有对象找到对应button
//            if ([view isEqual:self.redView.btn]) {
//                NSString *newTitle = [NSString stringWithFormat:@"哈哈%d", (arc4random() % 100)];
//                [self.redView.btn setTitle:newTitle forState:UIControlStateNormal];
//            }
//
////            if ([view isKindOfClass:[UIButton class]]) {
////                UIButton *btn = (UIButton *)view;
////                NSString *newTitle = [NSString stringWithFormat:@"哈哈%d", (arc4random() % 100)];
////                [btn setTitle:newTitle forState:UIControlStateNormal];
////            }
//        }
//    }];
}

- (void)testRACKVO {
    [self.redView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"testRACKVO value:%@, change: %@", value, change);
    }];
}

- (void)testRACProperty {
    [[self.redView rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"testRACProperty x:%@", x);
    }];
}

- (void)testRACSignal {
    // 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        self.subscriber = subscriber;
        // 若没有调用subscribeNext进不来
        NSLog(@"11111");
        
        [subscriber sendNext:@"aaaaaa"];
        
       return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被取消了！");
        }];
    }];
    
    // 订阅信号
    RACDisposable *disposable1 = [signal subscribeNext:^(id  _Nullable x) {
        // 若没有调用subscriber sendNext就进不来
        NSLog(@"订阅信号:%@", x);
    }];
    // nextblock作为属性值保存
    RACDisposable *disposable2 = [signal subscribeNext:^(id  _Nullable x) {
        // 若没有调用subscriber sendNext就进不来
        NSLog(@"再次订阅信号:%@", x);
    }];
    
    // 发送数据
    [self.subscriber sendNext:@"bbbbbb"];
    // 取消信号
    [disposable1 dispose];
    [self.subscriber sendNext:@"cccccc"];
    [disposable2 dispose];
    [self.subscriber sendNext:@"dddddd"];
}

- (void)testRACSubject {
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    // 订阅信号
    RACDisposable *disposabel1 = [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"1111接收到数据:%@", x);
    }];
    //
    RACDisposable *disposabel2 = [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"2222接收到数据:%@", x);
    }];
    // 发送数据
    [subject sendNext:@1111];
    [subject sendNext:@2222];
    // 执行sendCompleted后再发生不会接收到消息
//    [subject sendCompleted];
//    [subject sendNext:@3333];
    // 取消信号
    [disposabel1 dispose];
    [subject sendNext:@"disposabel1接收不到"];
    [disposabel2 dispose];
    [subject sendNext:@"都接收不到"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.redView.frame = CGRectMake(50, 200, 200, 200);
}

@end

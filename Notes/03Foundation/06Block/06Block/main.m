//
//  main.m
//  06Block
//
//  Created by dfang on 2019-9-2.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

#import "NSObject+Sum.h"
#import "SumManager.h"

// 完整block
void block1(void);
// block属性
void blockAttr(void);
// block参数
void blockParams(void);
// block作为返回参数
void blockReturn(void);
// 链式操作
void blockSum(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
//        block1();

//        blockAttr();
        
//        blockParams();
        
//        blockReturn();
        
        blockSum();
    }
    return 0;
}

// 完整block，若有返回值需要在实现时加上返回值类型
void block1 () {
    id(^block)(void) = ^id(void) {
        NSLog(@"无参数block！");
        return nil;
    };
    id result = block();
    NSLog(@"%@", result);
}

// block属性
void blockAttr () {
    Person *person = [[Person alloc] init];
    // 直接赋值
    person.eat = ^{
        NSLog(@"person eat 2222!");
    };
    // 先定义block再赋值
//    void(^blockaaa)(void) = ^(void) {
//        NSLog(@"person eat 1111!");
//    };
//    person.eat = blockaaa;
    person.eat();
}

// block参数
void blockParams () {
    Person *person = [[Person alloc] init];
    [person eat:^{
        NSLog(@"eat something!");
    }];
    person.eat();
}

// block作为返回参数
void blockReturn () {
    Person *person = [[Person alloc] init];
    [person eatWithFood:@"Apple"]();
    person.eatWith(@"Banana");
}

// 链式操作
void blockSum () {
//    SumManager *maker = [[SumManager alloc] init];
    int result = [NSObject sum:^(SumManager *maker) {
        // 最后执行时maker实际上是block中创建的mgr
        maker.add(5).add(18).add(7);
        maker.add(10).add(2);
    }];
    NSLog(@"result is %d", result); // result is 42
}

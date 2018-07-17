//
//  main.m
//  02Block
//
//  Created by dfang on 2018-8-17.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

void testNoParaNoReturn();
void testHasParaNoReturn();
void testHasParaHasReturn();
void testChangeExternalVariable();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //        testNoParaNoReturn();
        //        testHasParaNoReturn();
        //        testHasParaHasReturn();
        testChangeExternalVariable();
    }
    return 0;
}

// 无返回值无参数
void testNoParaNoReturn() {
    {
        NSLog(@"block------");
    }
    
    void (^block1)() = ^() {
        NSLog(@"block1 with no paramter and no return");
    };
    void (^block2)() = ^{
        NSLog(@"block2 no param and no return");
    };
    
    block1();
    block2();
}

// 有参数无返回值
void testHasParaNoReturn() {
    void (^starBlock)(int) = ^(int n){
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j <= i; ++j) {
                printf("*");
            }
            printf("\n");
            //            NSLog(@"*****");
        }
    };
    starBlock(5);
}

// 有参数有返回值
void testHasParaHasReturn() {
    int (^sumblock)(int, int) = ^(int a, int b){
        return a + b;
    };
    int sum = sumblock(10, 12);
    NSLog(@"sum is %d", sum);
}

void testChangeExternalVariable () {
    int a = 10;
    __block int b = 10;
    void (^block)(void);
    block = ^{
        NSLog(@"%d",a);
        // block 内部访问外面的变量，默认情况不能修改外面的局部变量，用__block这个关键字修饰就可以更改了
        b = 20;
        NSLog(@"%d",b);
    };
    
    block();
    NSLog(@"a:%d, b:%d", a, b); // 20
}

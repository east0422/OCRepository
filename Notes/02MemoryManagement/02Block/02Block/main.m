//
//  main.m
//  02Block
//
//  Created by dfang on 2018-8-17.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

void testNoParaNoReturn(void);
void testHasParaNoReturn(void);
void testHasParaHasReturn(void);
void testChangeExternalVariable(void);

// block普通局部变量传值，其他情况传址
void testBlock1(void);
void testBlock2(void);
void testBlock3(void);
void testBlock4(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testNoParaNoReturn();
//        testHasParaNoReturn();
//        testHasParaHasReturn();
//        testChangeExternalVariable();
        
        testBlock1();
//        testBlock2();
//        testBlock3();
//        testBlock4();
    }
    return 0;
}

// 无返回值无参数
void testNoParaNoReturn() {
    {
        NSLog(@"block------");
    }
    
    void (^block1)(void) = ^() {
        NSLog(@"block1 with no paramter and no return");
    };
    void (^block2)(void) = ^{
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

// 普通局部变量
void testBlock1() {
    int a1 = 10;
    void (^block1)(void) = ^() {
        NSLog(@"a1 is %d", a1);
    };
    a1 = 20;
    block1(); // a1 is 10
}

void testBlock2()
{
    __block int a2 = 10;
    void (^block2)(void) = ^{
        NSLog(@"a2 is %d", a2);
    };
    a2 = 20;
    block2(); // 20
}
void testBlock3()
{
    static int a3 = 10;
    void (^block3)(void) = ^{
        NSLog(@"a3 is %d", a3);
    };
    a3 = 30;
    block3(); // 30
}

int a4 = 10;
void testBlock4()
{
    void (^block4)(void) = ^{
        NSLog(@"a4 is %d", a4);
    };
    a4 = 40;
    block4(); // 40
}

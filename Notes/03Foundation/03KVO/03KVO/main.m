//
//  main.m
//  03KVO
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"
#import "Nanny.h"

#import "Person.h"

#import "Animal.h"
#import "NSObject+KVO.h"
#import "Dog.h"

// 监听对象属性
void testObjVar();
// 监听本质是Setter方法
void testActual();
// 监听数组
void testArr();
// KVO手动模式
void testManual();
// 自定义KVO
void testCustom();

// KVO实际监听的是setter方法
int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testObjVar();
//        testActual();
//        testArr();
//        testManual();
        testCustom();
    }
    return 0;
}

void testObjVar() {
    // nanny观察baby的hungryLevel值是否小于90
    Baby *baby = [[Baby alloc] init];
    Nanny *nanny = [[Nanny alloc] initWithBaby:baby];
    // 定义一个死循环不让程序结束，使得bab一直吃hungryLevel值减小
    [[NSRunLoop currentRunLoop] run];
}

void testActual() {
    // kvo本质是监听setter方法
    Person *person = [[Person alloc] init];

    // 对象属性
    Dog *dog = [[Dog alloc] init];
    person.dog = dog;
     // 方法一：需在Person中处理keyPathsForValuesAffectingValueForKey:或对应方法
    [person addObserver:person forKeyPath:@"dog" options:(NSKeyValueObservingOptionNew) context:nil];
    // 方法二：使用点语法
//    [person addObserver:person forKeyPath:@"dog.age" options:(NSKeyValueObservingOptionNew) context:nil];
//    [person addObserver:person forKeyPath:@"dog.name" options:(NSKeyValueObservingOptionNew) context:nil];
    dog.name = @"小花";
    dog.age = 5;
}

void testArr() {
     // 数组属性
    Person *person = [[Person alloc] init];
    person.arr = NSMutableArray.array;
    [person addObserver:person forKeyPath:@"arr" options:(NSKeyValueObservingOptionNew) context:nil];
    // 会观察到消息(更改了arr，调用了setter方法)
//    person.arr = [NSMutableArray arrayWithObject:@"aaa"];
    // 不会观察到消息(只是往arr中添加对象数据)
//    [person.arr addObject:@"bbb"];
    // 会观察到消息(使用mutableArrayValueForKey:获取arr对象)
    [[person mutableArrayValueForKey:@"arr"] addObject:@"ccc"];
}

void testManual() {
    // 若automaticallyNotifiesObserversForKey：返回NO则不会主动通知，需要手动通知
    Person *person = [[Person alloc] init];
    [person addObserver:person forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [person willChangeValueForKey:@"name"];
    person.name = @"小张";
    [person didChangeValueForKey:@"name"];
}

void testCustom() {
       // 自定义KVO
    Person *person = [[Person alloc] init];
    [person east_addObserver:person forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    // setter方法
    person.name = @"小明";
    NSLog(@"name:%@", person.name);
    person.name = @"大章";
    [person east_addObserver:person forKeyPath:@"nickname" options:NSKeyValueObservingOptionNew context:nil];
    // 直接访问成员变量，不会触发观察者
//    person->nickname = @"明明";
    // 调用setter方法会触发观察者
    [person setNickname:@"mingming1"];
    NSLog(@"nickname:%@", person->nickname);
    
    
    // 自定义观察者对象
//        Animal *animal1 = [[Animal alloc] init];
//        [animal1 east_addObserver:animal1 forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//        animal1.name = @"小花猫";
//        NSLog(@"%@", animal1.name);
}

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

// KVO实际监听的是setter方法
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // nanny观察baby的hungryLevel值是否小于90
//        Baby *baby = [[Baby alloc] init];
//        Nanny *nanny = [[Nanny alloc] initWithBaby:baby];
//        // 定义一个死循环不让程序结束，使得bab一直吃hungryLevel值减小
//        [[NSRunLoop currentRunLoop] run];
        
        // kvo本质是监听setter方法
        Person *person = [[Person alloc] init];
        [person east_addObserver:person forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
        // setter方法
        person.name = @"小明";
        NSLog(@"%@", person.name);
//        // 直接访问成员变量，不会触发观察者
//        person->nickName = @"明明";
//        // 调用setter方法会触发观察者
//        [person setNickName:@"mingming1"];
        
        
        // 自定义观察者对象
//        Animal *animal1 = [[Animal alloc] init];
//        [animal1 east_addObserver:animal1 forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//        animal1.name = @"小花猫";
//        NSLog(@"%@", animal1.name);
    }
    return 0;
}

//
//  main.m
//  01Predicate
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *array = @[
                           [Person personWithAge:20 andHeight:168],
                           [Person personWithAge:30 andHeight:178],
                           [Person personWithAge:25 andHeight:158],
                           [Person personWithAge:22 andHeight:180],
                           [Person personWithAge:29 andHeight:165],
                           [Person personWithAge:40 andHeight:119],
                           [Person personWithAge:20 andHeight:168],
                           [Person personWithAge:50 andHeight:199],
                           [Person personWithAge:33 andHeight:198],
                           ];
        NSArray *nameArray = @[
                       @{@"name":@"abc"},
                       @{@"name": @"jack"},
                       @{@"name": @"ijack"},
                       @{@"name": @"adaajack"},
                       ];
        
        // 获取年龄小于40
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < %d", 40];
        // 使用谓词把不合适的过滤
        NSArray *result1 = [array filteredArrayUsingPredicate:predicate];
        NSLog(@"result1=%@",result1);
        
        // 获取身高为180，年龄为22
        NSPredicate *pre2 = [NSPredicate predicateWithFormat:@"height = %d && age = %d", 180, 22];
        NSArray *result2 = [array filteredArrayUsingPredicate:pre2];
        NSLog(@"result2=%@",result2);
        
        // 年龄为在{22，18，33}
        NSPredicate *pre3 = [NSPredicate predicateWithFormat:@"age in {22, 18, 33}"];
        NSArray *result3 = [array filteredArrayUsingPredicate:pre3];
        NSLog(@"result3=%@",result3);
        
        // 包含某个字符  @"name CONTAINS 'b'
        // 以某某字符开头 @"name BEGINSWITH 'j'"
        // 以某某结束  @"name ENDWITH 'k'"
        NSPredicate *pre4 = [NSPredicate predicateWithFormat:@"name CONTAINS 'b'"];
        NSArray *result4 = [nameArray filteredArrayUsingPredicate:pre4];
        NSLog(@"result4=%@",result4);
        
        // 模糊查询  @"name like 'j*'å"  *任意多个字符  ？一个字符
        NSPredicate *pre5 = [NSPredicate predicateWithFormat:@"name like '?j*'"];
        NSArray *result5 = [nameArray filteredArrayUsingPredicate:pre5];
        NSLog(@"result5=%@",result5);
    }
    return 0;
}

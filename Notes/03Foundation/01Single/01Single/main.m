//
//  main.m
//  01Single
//
//  Created by dfang on 2018-8-17.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinglePerson.h"

void testSinglePerson();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        testSinglePerson();
    }
    return 0;
}

void testSinglePerson() {
    SinglePerson *person1 = [[SinglePerson alloc] init];
    SinglePerson *person2 = [[SinglePerson alloc] init];
    SinglePerson *person3 = [SinglePerson singlePersonInstance];
    SinglePerson *person4 = [SinglePerson singlePersonInstance];
    NSLog(@"\nperson1:%@ \nperson2:%@ \nperson3:%@ \nperson4:%@", person1, person2, person3, person4);
}

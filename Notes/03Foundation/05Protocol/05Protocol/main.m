//
//  main.m
//  05Protocol
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Student.h"
#import "Animal.h"
#import "Animal+Eat.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *person = [[Person alloc] init];
        [person test11];
        [person test12];
        [person test13];
        [person test21];
        
        NSLog(@"-----------");
        Student *student = [[Student alloc] init];
        [student test11];
        [student test12];
        [student test13];
        [student test21];
        [student study];
        
        NSLog(@"-----------");
        Animal *animal = [[Animal alloc] init];
        [animal test11];
        [animal test12];
        [animal test21];
    }
    return 0;
}



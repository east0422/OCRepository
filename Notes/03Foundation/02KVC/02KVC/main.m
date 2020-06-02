//
//  main.m
//  02KVC
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Human.h"
#import "NSObject+EASTKVC.h"
#import "Animal.h"
 
// valueForKey:优先级getter方法->集合方法->成员属性(accessInstanceVariablesDirectly返回TYES)

void testPerson(void);
void testHuman(void);
void testEASTKVC(void);
void testSetOperator(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testPerson();
//        testHuman();
//        testEASTKVC();
        testSetOperator();
    }
    return 0;
}

void testPerson() {
    Person *person = [[Person alloc] init];
//    person->_age = 10;    // default protected not allowed access
        
    // kvc
    // error: not key value coding-compliant for the key ageasaa.
//    [person setValue:@10 forKey:@"ageasaa"];
    
    [person setValue:@10 forKey:@"age"];    // call setAge age is 10
    [person setValue:@20 forKey:@"_age"];
    NSString *age = [person valueForKey:@"age"];  // call age and age is 20
    NSString *_age = [person valueForKey:@"_age"];
    NSLog(@"age is %@, _age is %@", age, _age); // age is 20, _age is 20
    
    [person setValue:@"mockname" forKey:@"name"];
    // error: not key value coding-compliant for the key _name
//        [person setValue:@"_mockname" forKey:@"_name"];
//        NSString *_name = [person valueForKey:@"_name"];
    
    NSLog(@"person:%@", person);    // person:name is mockname, age is 20
}

void testHuman() {
    Human *human = [[Human alloc] init];
//    // crash with uncaught exception valueForUndefinedKey:
//    NSString *category = [human valueForKey:@"human"];
//    NSLog(@"category is %@", category);
    
    NSObject *name = [human valueForKey:@"name"];
    NSLog(@"name is: %@", name);
    
    [human setValue:@"humanname" forKey:@"name"];
    NSLog(@"human is:%@", human);
}

void testEASTKVC() {
    Animal *animal = [[Animal alloc] init];
    
    NSString *name = [animal EAST_valueForKey:@"name"];
    NSLog(@"name is: %@", name);
    
//    [animal EAST_setValue:@"张三" forKey:nil];
    [animal EAST_setValue:@"小花" forKey:@"name"];
    NSLog(@"animal %@", animal);
}

// 集合运算符@count/@max/@min/@sum/@avg
void testSetOperator() {
    NSMutableArray *arr = NSMutableArray.array;
//    [arr addObject:@"1"];
//    NSLog(@"count is %lu", (unsigned long)arr.count);
//    NSLog(@"count is %@", [arr valueForKey:@"@count"]);
    
    Person *p1 = [[Person alloc] init];
    p1.age = 20;
    [arr addObject:p1];
    Person *p2 = [[Person alloc] init];
    p2.age = 80;
    [arr addObject:p2];
    Person *p3 = [[Person alloc] init];
    p3.age = 50;
    [arr addObject:p3];
    
    NSLog(@"count:%@, max:%@, min:%@, sum:%@, avg:%@", [arr valueForKey:@"@count"], [arr valueForKeyPath:@"@max.age"], [arr valueForKeyPath:@"@min.age"], [arr valueForKeyPath:@"@sum.age"], [arr valueForKeyPath:@"@avg.age"]);
}

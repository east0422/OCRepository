//
//  main.m
//  02KVC
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *person = [[Person alloc] init];
//        person->_age = 10;    // default protected not allowed access
        
        // kvc
        // error: not key value coding-compliant for the key ageasaa.
//        [person setValue:@10 forKey:@"ageasaa"];
        
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
    return 0;
}

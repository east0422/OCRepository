//
//  main.m
//  01ReferenceCount
//
//  Created by dfang on 2018-8-9.
//  Copyright © 2018年 east. All rights reserved.
//

// Build Settings -> Automatic Reference Counting(Yes -> No)

#import <Foundation/Foundation.h>
#import "Book.h"
#import "Person.h"
#import "Car.h"
#import "Card.h"

void testStr();
void testObj();
void testCycle();
void testAutoReleasePool();

int main(int argc, const char * argv[]) {
    // 字符串引用
//    testStr();
    
    // 对象引用
//    testObj();
    
    // 相互循环引用
//    testCycle();
    
    testAutoReleasePool();
    
    return 0;
}

// test NSString retaincount
void testStr() {
    NSLog(@"'str123' retaintcount:%ld", [@"str123" retainCount]); // -1
    
    NSString *str1 = [[NSString alloc] initWithString:@"str1"];
    NSLog(@"%ld", [str1 retainCount]);  // -1
    [str1 retain];
    NSLog(@"%ld", [str1 retainCount]);  // -1
    
    NSString *str2_2 = [NSString stringWithFormat:@"%s,%d", "str2_2",22];//__NSCFString
    NSLog(@"str2_2:%ld",[str2_2 retainCount]); // 1
    [str2_2 retain];
    NSLog(@"str2_2:%ld",[str2_2 retainCount]); // 2
    [str2_2 release];
    NSLog(@"str2_2:%ld",[str2_2 retainCount]); // 1
    [str2_2 copy];
    NSLog(@"str2_2:%ld",[str2_2 retainCount]); // 2
    [str2_2 release];
    NSLog(@"str2_2:%ld",[str2_2 retainCount]); // 1
    [str2_2 release];
    NSLog(@"str2_2:%ld",[str2_2 retainCount]); // 1152921504606846975
}

// 对象引用
void testObj() {
    Book *book1 = [[Book alloc] init];
    Person *person = [[Person alloc] init];
    person.book = book1;
    NSLog(@"book retaincount:%ld", [book1 retainCount]); // 2
    NSLog(@"person retaincount:%ld", [person retainCount]); // 1
    
    Book *book2 = [[Book alloc] init];
    person.book = book2; // retaincount + 1
    person.book = book2; // retaincount not change
    NSLog(@"book1 retaincount:%ld", [book1 retainCount]); // 1
    NSLog(@"book2 retaincount:%ld", [book2 retainCount]); // 2
    
    Car *car1 = [[Car alloc] init];
    car1.speed = 100;
    [person setCar:car1];
    Car *car2 = [[Car alloc] init];
    car2.speed = 200;
    [person setCar:car2];
    [car1 release];  // car(car1) dealloc
    
    [person release];   // person dealloc, book and car retaincount - 1
    [book1 release]; // book(book1) dealloc
    [car2 release];  // car(car2) dealloc
    [book2 release]; // book(book2) dealloc
}

// 相互循环引用
void testCycle() {
    Person *person = [[Person alloc] init];
    Card *card = [[Card alloc] init];
    person.card = card;
    card.person = person;
    
//    Car *car = [[Car alloc] init];
//    person.car = car;
//    Book *book = [[Book alloc] init];
//    person.book = book;
    
//    [card release];
    [person release];
}

// 自动释放池
void testAutoReleasePool() {
    @autoreleasepool {
        Person *person = [[[Person alloc] init] autorelease];
        person.book = [[[Book alloc] init] autorelease];
        person.car = [[[Car alloc] init] autorelease];
        person.card = [[[Card alloc] init] autorelease];
        NSLog(@"%@", person);
        
        @autoreleasepool {
            // overreleased while already deallocating
//            Car *car = [[[[Car alloc] init] autorelease] autorelease];
            Car *car = [[[Car alloc] init] autorelease];
            // overreleased while already deallocating; break on objc_overrelease_during_dealloc_error to debug
            // [car release];
            car.speed = 80;
        }
    }
}

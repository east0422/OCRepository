//
//  Person.h
//  01ReferenceCount
//
//  Created by dfang on 2018-8-9.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Book;
@class Car;
@class Card;

@interface Person : NSObject {
    Car *_car;
}

- (void)setCar: (Car *)car;
- (Car *)car;

// 指定为copy则需要实现Book的copyWithZone
@property (nonatomic, retain) Book *book;

// 相互循环引用，指定为weak/assign，对象通常使用若引用weak
@property (nonatomic, weak) Card *card;
@end

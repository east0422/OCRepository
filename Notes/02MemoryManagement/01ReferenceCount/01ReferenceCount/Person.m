//
//  Person.m
//  01ReferenceCount
//
//  Created by dfang on 2018-8-9.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Person.h"
#import "Car.h"
#import "Book.h"

@implementation Person

- (void)setCar: (Car *)car {
    if (_car != car) {
        [_car release];
        _car = [car retain];
    }
}

- (Car *)car {
    return _car;
}

- (void)dealloc
{
    [_car release];
    [_book release];
    
    NSLog(@"Person dealloc");
    
    [super dealloc];
}

@end

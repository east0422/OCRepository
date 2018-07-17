//
//  Car.m
//  01ReferenceCount
//
//  Created by dfang on 2018-8-10.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Car.h"

@implementation Car

- (void)dealloc
{
    NSLog(@"Speed为%d的Car dealloc", _speed);
    [super dealloc];
}

@end

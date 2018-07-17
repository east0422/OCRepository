//
//  Card.m
//  01ReferenceCount
//
//  Created by dfang on 2018-8-16.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Card.h"
#import "Person.h"

@implementation Card

- (void)dealloc
{
    [_person release];
    NSLog(@"Card dealloc");
    [super dealloc];
}

@end

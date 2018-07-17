//
//  Book.m
//  01ReferenceCount
//
//  Created by dfang on 2018-8-9.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Book.h"

@implementation Book

- (void)dealloc {
    NSLog(@"Book dealloc");
    
    [super dealloc];
}

@end

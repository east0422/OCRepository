//
//  Card.h
//  01ReferenceCount
//
//  Created by dfang on 2018-8-16.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;

@interface Card : NSObject

@property (nonatomic, strong) Person *person;

@end

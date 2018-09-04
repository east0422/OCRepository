//
//  Person.h
//  RuntimeArchived
//
//  Created by dfang on 2018-7-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    Male = 0,
    Female = 1,
} Sex;

@interface Person : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) Sex sex;

@end

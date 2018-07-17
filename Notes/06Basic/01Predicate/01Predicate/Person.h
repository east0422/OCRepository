//
//  Person.h
//  01Predicate
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger height;

+ (id)personWithAge:(NSInteger)age andHeight:(NSInteger)height;

@end

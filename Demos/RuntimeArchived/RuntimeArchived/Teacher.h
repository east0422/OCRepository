//
//  Teacher.h
//  RuntimeArchived
//
//  Created by dfang on 2018-7-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Teacher : Person

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) Person *spouse;

@end

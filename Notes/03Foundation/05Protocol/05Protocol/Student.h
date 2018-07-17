//
//  Student.h
//  05Protocol
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@protocol StudentProtocol <NSObject>

- (void)study;

@end

@interface Student: Person <StudentProtocol>

@end

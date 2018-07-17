//
//  Person.h
//  05Protocol
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolOne.h"
#import "ProtocolTwo.h"

@interface Person : NSObject <ProtocolOne, ProtocolTwo>

@end

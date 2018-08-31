//
//  Person+Marry.m
//  01RuntimeBasic
//
//  Created by dfang on 2018-8-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Person+Marry.h"

@implementation Person (Marry)

- (BOOL)marriedWith:(Person *)spouse {
    if (spouse.age > 18) {
        NSLog(@"%@ married with %@", self.name, spouse.name);
        return true;
    }
    
    NSLog(@"%@ not married with %@", self.name, spouse.name);
    return true;
}

@end

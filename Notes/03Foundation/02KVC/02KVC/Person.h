//
//  Person.h
//  02KVC
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
@protected
    int _age;
    NSString *name;
}

- (void)setAge:(int)age;
- (int)age;

@end

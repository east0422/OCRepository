//
//  Teacher.h
//  01RuntimeBasic
//
//  Created by dfang on 2018-8-31.
//  Copyright © 2018年 east. All rights reserved.
//

#import "Person.h"

@interface Teacher : Person {
    NSString *graduatedSchool; // 毕业学校
}

// 授课类别
@property (nonatomic, copy) NSString *teachClass;

// 吃鱼
- (void)eatFish;

@end

//
//  Person.h
//  03KVO
//
//  Created by dfang on 2019-8-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject {
    @public
    NSString *nickname;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Dog *dog;
@property (nonatomic, strong) NSMutableArray *arr;

-(NSString *)nickname;

-(void)setNickname: (NSString *)nickname;

@end

NS_ASSUME_NONNULL_END

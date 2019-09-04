//
//  Person.h
//  06Block
//
//  Created by dfang on 2019-9-2.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

// block作为属性
@property (nonatomic, strong) void(^eat)(void);

// block作为方法参数
- (void)eat:(void(^)(void))block;

// block作为返回值
- (void(^)(void))eatWithFood:(NSString *)food;

// block作为返回值
- (void(^)(NSString *food))eatWith;

@end

NS_ASSUME_NONNULL_END

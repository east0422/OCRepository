//
//  SumManager.h
//  06Block
//
//  Created by dfang on 2019-9-3.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SumManager : NSObject

@property (nonatomic, assign) int result;

// 点语法实际上就是对应的getter方法，返回SumManager *(^)(int)类型block
- (SumManager *(^)(int))add;

@end

NS_ASSUME_NONNULL_END

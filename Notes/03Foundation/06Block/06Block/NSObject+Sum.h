//
//  NSObject+Sum.h
//  06Block
//
//  Created by dfang on 2019-9-3.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SumManager;

@interface NSObject (Sum)

+ (int)sum:(void(^)(SumManager *sumManagerMaker))block;

@end

NS_ASSUME_NONNULL_END

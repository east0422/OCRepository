//
//  NSObject+KVO.h
//  03KVO
//
//  Created by dfang on 2019-8-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)

// 添加观察者
- (void)east_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

// 删除观察者
- (void)east_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context;

@end

NS_ASSUME_NONNULL_END

//
//  OperationQueue.h
//  003NSOperation
//
//  Created by dfang on 2019-11-22.
//  Copyright © 2019 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OperationQueue : NSObject

/** 取消队列中所有操作 */
- (void)cancelAll;

/** 暂停操作 */
- (void)pause;

/** 依赖 */
- (void)testDependency;

/** 最大并发数 */
- (void)testMaxConcurrentCount;

/** 主队列中操作NSBlockOperation */
- (void)testBlockInMain;

/** NSBlockOperation multiple task */
- (void)testBlockWithMultipleTask;

/** NSBlockOperation with one task*/
- (void)testBlock;

/** NSInvocationOperation */
- (void)testInvocation;

@end

NS_ASSUME_NONNULL_END

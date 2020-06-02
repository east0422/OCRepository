//
//  ThreadLock.h
//  004ThreadSafe
//
//  Created by dfang on 2020-5-23.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThreadLock : NSObject

/** 非原子属性 */
@property (nonatomic, copy) NSString *nonatomicStr;
/** 原子属性(也并非绝对线程安全) */
@property (atomic, copy) NSString *atomicStr;
/** 测试原子属性和非原子属性区别 */
- (void)testAtomic;

/** nslock */
@property (atomic, assign) NSInteger num;
- (void)testNSLock;

/** @synchronized */
- (void)testSynchronized;

/** semaphore */
- (void)testSemaphore;

/** os_unfair_lock是互斥锁 */
- (void)testOSUnfairLock;

/** pthread_mutex */
- (void)testPthreadMutex;

/** nscondition */
- (void)testNSCondition;

/** nsconditionlock */
- (void)testNSConditionLock;



@end

NS_ASSUME_NONNULL_END

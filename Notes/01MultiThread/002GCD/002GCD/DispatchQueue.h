//
//  DispatchQueue.h
//  002GCD
//
//  Created by dfang on 2019-11-21.
//  Copyright © 2019 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DispatchQueue : NSObject

/** print Hello world! */
- (void)printHello;

/** dispatch_async use serial queue */
- (void)testSerialQueueWithAsync;
/** dispatch_async use concurrent queue */
- (void)testConcurrentQueueWithAsync;
/** dispatch_async use main queue */
- (void)testMainQueueWithAsync;
/** dispatch_async use global queue */
- (void)testGlobalQueueWithAsync;

/** dispatch_sync use serial queue */
- (void)testSerialQueueWithSync;
/** dispatch_sync use concurrent queue */
- (void)testConcurrentQueueWithSync;
/** dispatch_sync use main queue */
- (void)testMainQueueWithSync;
/** dispatch_sync use global queue */
- (void)testGlobalQueueWithSync;

/** dispatch_barrier_async use concurrent queue */
- (void)testConcurrentQueueWithBarrierAsync;
/** dispatch_barrier_sync use concurrent queue */
- (void)testConcurrentQueueWithBarrierSync;

/** dispatch_sync and dispatch_async use concurrent queue */
- (void)testConcurrentWithMix;

/** MutableDictionary not thread safe */
- (void)testMutableDictionaryThreadSafe;

/** dispatch_once */
- (void)testDispatchOnce;

/** dispatch_group */
- (void)testDispatchGroup;

/** dispatch_after */
- (void)testDispatchDelay;

@end

NS_ASSUME_NONNULL_END

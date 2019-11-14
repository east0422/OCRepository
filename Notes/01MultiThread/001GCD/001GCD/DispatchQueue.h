//
//  DispatchQueue.h
//  001GCD
//
//  Created by dfang on 2019-11-13.
//  Copyright © 2019年 east. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef DispatchQueue_h
#define DispatchQueue_h

/** print Hello world! */
void printHello(void);

/** dispatch_async use serial queue */
void testSerialQueueWithAsync(void);
/** dispatch_async use concurrent queue */
void testConcurrentQueueWithAsync(void);

/** dispatch_sync use serial queue */
void testSerialQueueWithSync(void);
/** dispatch_sync use concurrent queue */
void testConcurrentQueueWithSync(void);

/** dispatch_barrier_async use concurrent queue */
void testConcurrentQueueWithBarrierAsync(void);
/** dispatch_barrier_sync use concurrent queue */
void testConcurrentQueueWithBarrierSync(void);

void testMutableDictionaryThreadSafe(void);

#endif /* DispatchQueue_h */

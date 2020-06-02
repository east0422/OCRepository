# 线程安全


#### 简述
1. 多线程操作共享数据不会出现想不到的结果就是线程安全的，否组是线程不安全的。
2. 线程安全针对多线程的，多线程中常使用锁(确保只有一条线程在存取数据)来保证线程安全。个人理解线程锁就是该线程执行完成之前禁止其他线程对锁定部分进行读写。

#### 自旋锁与互斥锁
1. 都能保证同一时间只有一个线程访问共享资源，都能保证线程安全。
2. 互斥锁若共享数据已经有其他线程加锁了，线程会进入休眠状态等待锁，一旦被访问的资源被解锁则等待资源的线程会被唤醒(只是唤醒还需要等待cpu调度执行)。
3. 自旋锁若共享数据已经有其他线程加锁了，线程会以死循环的方式等待锁，一旦被访问的资源被解锁则等待资源的线程会立即执行。
4. 自旋锁不释放cpu(效率高于互斥锁)，因此持有自旋锁的线程应尽快释放自旋锁，否则等待该自旋锁的线程会一直在哪里自旋会浪费cpu时间。持有自旋锁的线程在sleep前应释放自旋锁以便其他线程可获得该自旋锁。

#### atomic与nonatomic
1. 原子操作是指不可打断分割的操作，就是说线程在执行操作过程中，不会被操作系统挂起而是一定会执行完。原子属性在setter方法时会加锁，多个线程访问时不会出错，但是最终结果不确定(单线程安全，多线程不安全)。
2. 非原子属性在setter方法时没加锁，多个线程访问时会崩溃，在某一时刻可能一个线程使用了另一个线程只处理一部分的结果(retain/release可能连续多次)。

#### os_unfair_lock
1. OSSpinLock替代品，性能优异，需要引入头文件<os/lock.h>。
2. 代码实现

	```
	os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
  	dispatch_apply(3, queue, ^(size_t index) {
  		os_unfair_lock_lock(&lock);
     	[self printTest];
    	os_unfair_lock_unlock(&lock);
   });
	```

#### dispatch_semaphore
1.是gcd提供的，使用信号量来控制并发线程的数量(可同时进入并执行加锁代码块的线程的数量)。
2. 首先创建一个信号量并初始化值为1，在使用前先将信号量减一判断是否大于等于0，若是返回0并继续执行后续代码，否则使线程进入睡眠状态让出cpu时间，直到信号量大于0或超时则线程会被重新唤醒执行后续操作。
3. 代码实现

	```
	dispatch_async(queue, ^{
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
		// 执行代码
		dispatch_semaphore_signal(semaphore);
	});
	dispatch_async(queue, ^{
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
		// 执行代码
		dispatch_semaphore_signal(semaphore);
	});
	```
	
#### pthread_mutex
1. 阻塞线程并进入睡眠，需要进行上下文切换，需要引入头文件<pthread.h>。
2. 代码实现
	
	```
	// 需引入头文件pthread.h
	pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
   dispatch_apply(3, queue, ^(size_t index) {
	   pthread_mutex_lock(&mutex);
	   [self printTest];
	   pthread_mutex_unlock(&mutex);
   });
	```
	
#### NSLock
1. 是OC层封装底层线程操作来实现的一种锁，继承NSLocking协议。
2. 代码实现

	```
    NSLock *lock = [NSLock new];
    dispatch_apply(10000, queue, ^(size_t index) {
	   [lock lock];
	   // 执行代码
	   [lock unlock];
    });
	```
	
#### NSCondition
1. 常用于生产者-消费者模式，它继承于NSLocking协议，封装了一个互斥锁和条件变量(条件变量类似信号量，提供了线程阻塞与信号机制，可用来阻塞某个线程并等待线程就绪再唤醒线程)，互斥锁保证线程安全，条件变量保证执行顺序。
2. 代码实现

	```
	// 还有wait(挂起线程)/signal(唤醒线程)等方法
	NSCondition *condition = [NSCondition new];
  	dispatch_apply(3, queue, ^(size_t index) {
	   [condition lock];
	   // 执行代码
	   [condition unlock];
   });
	```
	
#### NSConditionLock
1. 条件锁，借助NSCondition来实现，本质是生产者-消费者模型。
2. 内部持有一个NSCondition对象以及_condition_value属性，在初始化时就会对这个属性进行赋值。
3. lockWhenCondition:是当condition参数与NSConditionLock属性condition值相等时才可加锁。unlockWithCondition:不是当condition符合条件时才解锁，而是解锁后修改属性condition值为参数值。
4. 代码实现

	```
	// 还有lockWhenCondition:/unlockWithCondition:等方法
	NSConditionLock *conditionLock = [NSConditionLock new];
   dispatch_apply(3, queue, ^(size_t index) {
	   [conditionLock lock];
	   // 执行代码
	   [conditionLock unlock];
    });
	```

#### @synchronized
1. 一个对象层面的锁，锁住了整个对象，底层使用了互斥递归锁来实现。参数需要传一个OC对象，它实际上是把这个对象当做锁的唯一标识。
2. 代码实现

	```
	NSObject *obj = [NSObject new];
	dispatch_async(queue, ^{
		@synchronized(obj) {
			// 执行代码
		}
	});
	dispatch_async(queue, ^{
		@synchronized(obj) {
			// 执行代码
		}
	});
	```


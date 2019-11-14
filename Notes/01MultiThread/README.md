# 多线程

#### 底层实现
1. Mach是第一个以多线程方式处理任务的系统，因此多线程的底层实现机制是基于Mach的线程。由于Mach级的线程没有提供多线程的基本特征所以开发中很少用Mach级的线程。线程间是独立的。
2. 开发中实现多线程方案：
	* C语言的POSIX接口：#include <pthread.h>
	* OC的NSThread
	* C语言的GCD接口(性能最好代码更精简)
	* OC的NSOperation和NSOperationQueue(基于GCD)

#### 进程
1. 进程是指在系统中正在运行的一个应用程序。
2. 每个进程之间是独立的，每个进程运行在其自己专用且受保护的内存空间里。
3. 是具有一定独立功能的程序关于某个数据集合上的一次运行活动，是系统进行资源分配和调度的一个独立单位。
4. 进程和线程都是由操作系统所产生的程序运行的基本单元，系统利用该基本单元实现系统对应用的并发性。
5. 进程和线程的主要区别在于它们是不同的操作系统资源管理方式。
6. 进程有独立的地址空间，一个进程崩溃后，在保护模式下不会对其它进程产生影响。

#### 线程
1. 线程是进程的基本执行单元，一个进程的所有任务都在线程中执行。
2. 一个线程中任务的执行是串行(顺序执行)的，也就是说在同一时间内，一个线程只能执行一个任务，例如在一个线程中要下载三个文件只能一个一个的下载。线程只是一个进程中的不同执行路径。
3. 若要在一个线程中执行多个任务，则只能一个一个地按顺序执行这些任务。
4. 是进程的一个实体，是CPU调度和分派的基本单位，是比进程更小的能独立运行的基本单位。
5. 线程基本上不拥有系统资源，只拥有一点在运行中必不可少的资源(如程序计数器，一组寄存器和栈)，但是它可与同属一个进程的其他的线程共享进程所拥有的全部资源。
6. 一个线程可以创建和撤销另一个线程，同一个进程中的多个线程之间可以并发执行。相对进程而言，线程是一个更加接近于执行体的概念，它可以与同进程中的其他线程共享数据，但拥有自己的栈空间，拥有独立的执行序列。
7. 线程执行开销小，但不利于资源的管理和保护。
8. 线程有自己的堆栈和局部变量，但线程之间没有单独的地址空间，一个线程死掉就等于整个进程死掉，所以多进程的程序要比多线程的程序健壮，但在进程切换时，耗费资源较大，效率要差一些。
9. 对于一些要求同时进行并且又要共享某些变量的并发操作，只能用线程，不能用进程。

#### 线程间通信
1. NSMachPort
	1. 基本机制：A线程(父线程）创建NSMachPort对象，并加入A线程的runloop。当创建B线程(辅助线程)时，将创建的NSMachPort对象传递到主体入口点，B线程(辅助线程）就可以使用相同的端口对象将消息传回A线程(父线程）。
2. performSelector:onThread:withObject:waitUntilDone:
3. gcd的dispatch_async
4. NSOperationQueue与NSOperation

#### 如何避免网络地址重复请求
1. 利用字典(请求地址设为key, 请求下载操作设为value, 请求前判断字典中是否有对应的key)。

#### 多线程
	能适当提高程序的执行效率和资源(CPU，内存)利用率，但是开启线程需要占用一定的内存空间（默认情况下，主线程占用1M，子线程占用512KB），若开启大量的线程会占用大量的内存空间，降低程序的性能。线程越多，CPU在调度线程上的开销也就越大。Mach是第一个以多线程方式处理任务的系统，因此多线程的底层实现机制是基于Mach的线程。开发中很少用Mach级的线程，因为Mach级的线程没有提供多线程的基本特征，线程之间是独立的。
1. pthread
  1. 简介：POSIX线程，是线程的POSIX标准。是一套通用的多线程API，可以在Unix/Linux/Mac OS X等系统跨平台使用，Windows中也有其移植版pthread-win32。使用C语言编写，需要程序员自己管理线程的生命周期，在开发中几乎不使用。
  2. 使用
     * 包含头文件#import <pthread.h>
     * 创建线程，并开启线程执行任务

		```
		// 定义一个pthread_t类型变量
		pthread_t thread;
		// 创建线程，开启线程，执行任务
		pthread_create(&thread, NULL, run, NULL);
		// 设置子线程的状态为detached，该线程运行结束后会自动释放所有资源
		pthread_detach(thread);
		// run方法
		void *run(void *param) {
			NSLog(@“%@”, [NSThread currentThread]);
			return NULL;
		}
		```
2. NSThread
   1. 先创建后启动（可对线程进行更详细的设置，例如线程名字）
   
		```
		NSThread *thread = [[NSThread alloc] initWithTarget:self selector:      @selector(download:) object:nil];     	[thread start];
		```
   2. 创建完自动启动 
		```
		[NSThread detachNewThreadSelector:@selector(download:) toTarget:self withObject:nil];
		```
   3. 隐式创建（自动启动） 
		```
		[self performSelectorInBackground:@selector(download:) withObject:nil];
		```
3. GCD（核心为任务和队列，即执行什么操作和用来存放任务）
   1. 同步：在当前线程中执行任务，不具备开启新线程的能力 `dispatch_sync(dispatch_queue_t queue, dispatch_block_t block)`，queue为队列，block为任务
	2. 异步：马上执行，在新的线程中执行任务，具备开启新线程的能力。 `dispatch_async(dispatch_queue_t queue, dispatch_block_t block)`。
	3. 并发：多个任务并发(同时)执行(自动开启多个线程同时执行任务，开启线程时间由GCD底层决定)，只在异步下有效。使用`dispatch_get_global_queue`函数可获得全局并发队列。
	4. 串行：多个任务一个一个执行，一个任务执行完成后再执行下一个任务，最多开一个线程。使用`dispatch_queue_create`函数可创建串行队列。
	5. 主队列：专门负责在主线程上调度任务，即与主线程相关联的队列，不会在子线程调度任务。在主队列不允许开启新线程。主队列是GCD自带的一种特殊的串行队列，放在主队列中的任务都会放到主线程中执行。可使用`dispatch_get_main_queue()`获得主队列串。
		* 串行队列同步执行：不开线程，在原线程中一个一个顺序执行。
		* 串行队列异步执行：开一个新线程，在新线程中一个一个顺序行。
		* 并发队列同步执行：不开线程，在原线程中一个一个顺序执行。
		* 并发队列异步执行：开多个新线程，在新线程中并发(执行先后顺序不确定）执行。
		* 主队列同步执行：会造成死锁(主线程和主队列相互等待，卡住主线程)。
		* 主队列异步执行：不会开启新线程，先执行主线程中的任务再执行异步队列中任务。
   6. 只执行一次
		
		```
		static dispatch_once_t onceToken;
    	dispatch_once(&onceToken, ^{
     		// 执行代码，这里面默认是线程安全的
	   });
		```	
   7. 队列组(异步调用A、B完成后再做C)
		
		```
		// 创建一个队列组
		dispatch_group_t group = dispatch_group_create();
		// 获取一个全局并发队列
		dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_group_async(group, queue, ^{
			// 执行耗时操作A
		});
		dispatch_group_async(group, queue, ^{
			// 执行耗时操作B
		});
		// 监听操作A和操作B执行完后通知执行操作C
		dispatch_group_notify(group, queue, ^{
			// 执行操作C
		});
		```	
4. NSOperation：先将需要执行的操作封装到一个NSOperation对象中，然后将NSOperation对象添加到NSOperationQueue中，系统会自动将NSOperationQueue中的NSOperation取出来放到一条新线程中异步执行。
	1. NSInvocationOperation：
		
		```
		// 创建NSInvocationOperation对象
		- (id)initWithTarget:(id)target selector:(SEL)sel object:(id)arg;
		// 调用start方法开始执行操作，一旦执行操作就会调用target的sel方法
		- (void)start;
		// 注意：默认情况下，调用了start方法后并不会开一条新线程去执行操作，而是在当前线程中同步执行操作，只有将NSOperation放到一个NSOperationQueue中，才会异步执行操作。
		```
   2. NSBlockOperation： 
		```
		// 创建NSBlockOperation对象
		+ (id)blockOperationWithBlock:(void (^)(void))block;
		// 通过addExecutionBlock：方法添加更多的操作
		- (void)addExecutionBlock:(void (^)(void))block;
		// 注意：只要NSBlockOperation封装的操作数大于1就会异步执行操作。
		```
	3. 自定义NSOperation子类重写main方法：经常通过-(BOOL)isCancelled方法检测操作是否被取消，对取消做出响应。
	4. 添加任务到NSOperationQueue中 
		```
		- (void)addOperation:(NSOperation *)operation; 
		- (void)addOperationWithBlock:(void (^)(void))block;
		```
	5. 设置最大并发数，最大并发数不是线程总数，而是同时执行线程最多个数
		
		```
		- (NSInteger)maxConcurrentOperationCount; 
		- (void)setMaxConcurrentOperationCount:(NSInteger)cnt;
		```
	6. 取消所有操作，正在执行的不会被取消会继续执行完 
		```
		- (void)cancelAllOperations;
		// 也可以调用NSOperation的
		- (void)cancel方法取消单个操作
		```
  7. 暂停和恢复所有操作： 
		```
		// YES代表暂停队列，NO代表恢复队列
		- (void)setSuspended:(BOOL)b;
		```
	8. 操作之间的依赖，可以跨队列，NSOperation之间可以设置依赖来保证执行顺序，不能相互依赖，如A依赖B，B依赖A。 
		```
		// 操作B依赖于操作A，等操作A执行完毕后，才会执行操作B。
		[operationB addDependency:operationA];
		```
	9. 监听操作执行完毕：
		
		```
		- (void (^)(void))completionBlock;
		- (void)setCompletionBlock:(void (^)(void))block
		```
5. 线程间通信
	1. thread：
  
		```
		- (void)performSelector:(SEL)aSelector onThread: (NSThread *)thread withObject: (id)arg waitUntilDone: (BOOL)wait;
		```
   2. gcd： 
		```
		dispatch_async(dispatch_get_global_queue(   DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
	  		// 执行耗时的异步操作...
	  		dispatch_async(dispatch_get_main_queue(), ^{
	  			// 回到主线程，执行UI刷新操作
	  		});
  		});
		```
   3. NSOperation： 
		```
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		[queue addOperationWithBlock:^{
			// 1.执行一些比较耗时的操作
			// 2.回到主线程
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				// 执行更新操作
			}];
		}];
		```
6. 从其他线程回到主线程
	 1. perform：

		```
		[self performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>];
		```
	 2. gcd：

		```
		dispatch_async(dispatch_get_main_queue(), ^{});
		```
	 3. NSOperation：
	 
		```
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{}];
		```
7. 延时执行
   1. NSObject：
   
		```
		[self performSelector:@selector(method) withObject:nil afterDelay: 1.0];
		```
   2. gcd：

		```
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     		// 延迟执行代码
     	});
		```

#### 执行A、B后再执行C
1. 使用NSOperation和NSOperationQueue相对简单
	
	```
	// 创建队列
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	NSOperation *a = [NSBlockOperation blockOperationWithBlock:^{
		// 处理A
	}];
	// 类似创建b和c
	// 添加依赖
	[c addDependency:a];
	[c addDependency:b};
	// 执行操作
	[queue addOperation:a];
	[queue addOperation:b];
	[queue addOperation:c];
	```
2. Dispatch Group(见上)。
3. Dispatch信号量。
	
#### cocoa常见多线程实现，多线程安全解决方法及多线程安全控制
1. 只在主线程中刷新访问UI。
2. 若要防止资源抢夺，得用synchronized进行加锁保护。
3. 若异步操作要保证线程安全等问题，尽量使用GCD(有些函数默认安全)。

#### NSOperation
1. 抽象类，不能直接使用，需要使用其子类(和核心动画CAAnimation类似)NSInvocationOperation(调用)和NSBlockOperation(块)。
2. NSInvocationOperation和NSBlockOperation没有本质区别，只是后者使用Block的形式组织代码，使用相对方便。
3. NSInvocationOperation在调用start方法后，不会开启新的线程只会在当前线程中执行。
4. NSBlockOperation在调用start方法后，如果封装的操作数大于1就会开辟多条线程执行，等于1时只会在当前线程执行。

#### NSOperationQueue与GCD区别
1. GCD是纯C语言的API，是iOS4.0推出的，主要针对多核cpu做了优化。NSOperationQueue是基于GCD的OC版本封装。
2. GCD只支持FIFO的队列，NSOperationQueue可以很方便地调整执行顺序、设置最大并发数量。
3. NSOperationQueue创建的操作队列默认为全局队列，队列中的操作顺序是无序的，若要让它有序执行需添加依赖关系。NSOperationQueue可以轻松在Operation间设置依赖关系(如op2依赖于op1 [op2 addDependency: op1])，而GCD需要写很多代码才能实现。
4. NSOperationQueue支持KVO，可以监测operation是否正在执行(isExecuted)、是否结束(isFinished)、是否取消(isCanceled)。
5. GCD的执行速度比NSOperationQueue快。
6. 任务间互相不太依赖，需要更高的并发能力推荐使用GCD(苹果专门为GCD做了性能上的优化)；任务间有依赖或要监听任务的执行情况，异步操作的过程需要更多的被交互和UI呈现出来则推荐使用NSOperationQueue。
7. 高德纳的教诲：“在大概97%的时间里，我们应该忘记微小的性能提升。过早优化是万恶之源。”只有Instruments显示有真正的性能提升时才有必要用低级的GCD。

#### UNIX进程通信(主要支持三种通信方式)
1. 基本通信：主要用来协调进程间的同步和互斥。
	* 锁文件通信：通信的双方通过查找特定目录下特定类型的文件(称锁文件)来完成进程间对临界资源访问时的互斥；例如进程p1访问一个临界资源，首先查看是否有一个特定类型文件，若有，则等待一段时间再查找锁文件。
2. 管道通信：适应大批量的数据传递。
3. IPC：适应大批量的数据传递。
4. 进程的同步机制原子操作、信号量机制、自旋锁、管程、会合、分布式系统
	* 进程间通信的途径：共享存储系统消息传递系统管道，以文件系统为基础。
	* 进程死锁的原因：资源竞争及进程推进顺序非法。
	* 死锁的4个必要条件：互斥、请求保持、不可剥夺、环路。
	* 死锁的处理：鸵鸟策略、预防策略、避免策略、检测与解除死锁。





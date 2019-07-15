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

#### 线程
1. 线程是进程的基本执行单元，一个进程的所有任务都在线程中执行。
2. 一个线程中任务的执行是串行(顺序执行)的，也就是说在同一时间内，一个线程只能执行一个任务，例如在一个线程中要下载三个文件只能一个一个的下载。
3. 若要在一个线程中执行多个任务，则只能一个一个地按顺序执行这些任务。
4. 是进程的一个实体，是CPU调度和分派的基本单位，是比进程更小的能独立运行的基本单位。
5. 线程基本上不拥有系统资源，只拥有一点在运行中必不可少的资源(如程序计数器，一组寄存器和栈)，但是它可与同属一个进程的其他的线程共享进程所拥有的全部资源。
6. 一个线程可以创建和撤销另一个线程，同一个进程中的多个线程之间可以并发执行。相对进程而言，线程是一个更加接近于执行体的概念，它可以与同进程中的其他线程共享数据，但拥有自己的栈空间，拥有独立的执行序列。
7. 线程执行开销小，但不利于资源的管理和保护。

#### 线程间通信
1. NSMachPort
2. performSelector:onThread:withObject:waitUntilDone:
3. gcd的dispatch_async
4. NSOperationQueue与NSOperation

#### 如何避免网络地址重复请求
1. 利用字典(请求地址设为key, 请求下载操作设为value, 请求前判断字典中是否有对应的key)。

#### 多线程
	能适当提高程序的执行效率和资源(CPU，内存)利用率，但是开启线程需要占用一定的内存空间（默认情况下，主线程占用1M，子线程占用512KB），若开启大量的线程会占用大量的内存空间，降低程序的性能。线程越多，CPU在调度线程上的开销也就越大。
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
		`NSThread *thread = [[NSThread alloc] initWithTarget:self selector:      @selector(download:) object:nil];     	[thread start];`
   2. 创建完自动启动 `[NSThread detachNewThreadSelector:@selector(download:) toTarget:self withObject:nil];`
   3. 隐式创建（自动启动） `[self performSelectorInBackground:@selector(download:) withObject:nil];`
3. GCD（核心为任务和队列，即执行什么操作和用来存放任务）
   1. 同步：在当前线程中执行任务，不具备开启新线程的能力 `dispatch_sync(dispatch_queue_t queue, dispatch_block_t block)`，queue为队列，block为任务
	2. 异步：马上执行，在新的线程中执行任务，具备开启新线程的能力。 `dispatch_async(dispatch_queue_t queue, dispatch_block_t block)`。
	3. 并发：多个任务并发(同时)执行(自动开启多个线程同时执行任务，开启线程时间由GCD底层决定)，只在异步下有效。使用`dispatch_get_global_queue`函数可获得全局并发队列。
	4. 串行：多个任务一个一个执行，一个任务执行完成后再执行下一个任务，最多开一个线程。使用`dispatch_queue_create`函数可创建串行队列。
	5. 主队列：专门负责在主线程上调度任务，即与主线程相关联的队列，不会在子线程调度任务。在主队列不允许开启新线程。主队列是GCD自带的一种特殊的串行队列，放在主队列中的任务都会放到主线程中执行。可使用`dispatch_get_main_queue()`获得主队列串。
		* 行队列同步执行：不开线程，在原线程中一个一个顺序执行。
		* 串行队列异步执行：开一个新线程，在新线程中一个一个顺序行。
		* 并发队列同步执行：不开线程，在原线程中一个一个顺序执行。
		* 并发队列异步执行：开多个新线程，在新线程中并发(执行先后顺序不确定）执行。
		* 主队列同步执行：死锁。
		* 主队列异步执行：不会开启新线程，先执行主线程中的任务再执行异步队列中任务。
   6. 只执行一次
		`static dispatch_once_t onceToken;
	    dispatch_once(&onceToken, ^{
	      // 执行代码，这里面默认是线程安全的
	    });
		`
   7. 队列组   
		`
		// 创建一个队列组
		dispatch_group_t group = dispatch_group_create();
		// 获取一个全局队列
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
		`	
4. NSOperation
	先将需要执行的操作封装到一个NSOperation对象中，然后将NSOperation对象添加到NSOperationQueue中，系统会自动将NSOperationQueue中的NSOperation取出来放到一条新线程中异步执行。
	1. NSInvocationOperation： `// 创建NSInvocationOperation对象 - (id)initWithTarget:(id)target selector:(SEL)sel object:(id)arg; // 调用start方法开始执行操作，一旦执行操作就会调用target的sel方法 - (void)start; 注意：默认情况下，调用了start方法后并不会开一条新线程去执行操作，而是在当前线程中同步执行操作，只有将NSOperation放到一个NSOperationQueue中，才会异步执行操作。`
   2. NSBlockOperation： `// 创建NSBlockOperation对象 + (id)blockOperationWithBlock:(void (^)(void))block; // 通过addExecutionBlock：方法添加更多的操作 - (void)addExecutionBlock:(void (^)(void))block; 注意：只要NSBlockOperation封装的操作数大于1就会异步执行操作。`
	3. 自定义NSOperation子类重写main方法：经常通过-(BOOL)isCancelled方法检测操作是否被取消，对取消做出响应。
	4. 添加任务到NSOperationQueue中 `- (void)addOperation:(NSOperation *)op;  - (void)addOperationWithBlock:(void (^)(void))block;`
	5. 设置最大并发数，最大并发数不是线程总数，而是同时执行线程最多个数`- (NSInteger)maxConcurrentOperationCount;  - (void)setMaxConcurrentOperationCount:(NSInteger)cnt;`
	6. 取消所有操作，正在执行的不会被取消会继续执行完 `- (void)cancelAllOperations;// 也可以调用NSOperation的 - (void)cancel方法取消单个操作`
  7. 暂停和恢复所有操作： `- (void)setSuspended:(BOOL)b; // YES代表暂停队列，NO代表恢复队列`
	8. 操作之间的依赖，可以跨队列，NSOperation之间可以设置依赖来保证执行顺序，不能相互依赖，如A依赖B，B依赖A。 `[operationB addDependency:operationA]; // 操作B依赖于操作A，等操作A执行完毕后，才会执行操作B。`
	9. 监听操作执行完毕：
		`- (void (^)(void))completionBlock; - (void)setCompletionBlock:(void (^)(void))block`
5. 线程间通信
	1. thread：
   ` - (void)performSelector:(SEL)aSelector onThread: (NSThread *)thread withObject: (id)arg waitUntilDone: (BOOL)wait;`
   2. gcd： `dispatch_async(dispatch_get_global_queue(   DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{    // 执行耗时的异步操作...    dispatch_async(dispatch_get_main_queue(), ^{        // 回到主线程，执行UI刷新操作    });  });`
   3. NSOperation： `NSOperationQueue *queue = [[NSOperationQueue alloc] init]; [queue addOperationWithBlock:^{    // 1.执行一些比较耗时的操作   // 2.回到主线程   [[NSOperationQueue mainQueue] addOperationWithBlock:^{      // 执行更新操作    }];   }];`
6. 从其他线程回到主线程
	 1. perform： `[self performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>];`
	 2. gcd：`dispatch_async(dispatch_get_main_queue(), ^{});`
	 3. NSOperation：`[[NSOperationQueue mainQueue] addOperationWithBlock:^{}];`
7. 延时执行
   1. NSObject：`[self performSelector:@selector(method) withObject:nil afterDelay: 1.0];`
   2. gcd：`dispatch_after(dispatch_time(DISPATCH_TIME_NOW,       (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      // 延迟执行代码     });`

#### Dispatch Queue
1. Dispatch Queue是一个任务执行队列，可以让你异步或同步地执行多个Block或函数。Dispatch Queue是FIFO，即先入队的任务总会先执行。
2. 三种类型
	* 串行队列(Serial dispatch queue)：一次只能处理一个任务，可以由用户调用`dipatch_queue_create("come.example.MyQueue", NULL)`创建，第一个参数是串行队列标识，一般用反转域名的格式表示以防冲突，第二个参数是queue的类型，设为NULL时默认是DISPATCH_QUEUE_SERIAL，将创建串行队列，在必要情况下，你可以将其设置为DISPATCH_QUEUE_CONCURRENT来创建自定义并行队列。
	* 并发队列(Concurrent dispatch queue)：可以同时处理多个任务，在不得已的情况下可以用dispatch_queue_create创建，但一般我们都要用系统预定义的并行队列，即全局队列(Global Concurrent Dispatch Queues)。目前系统预定义了四个不同运行优先级的全局队列，我们可以通过dispatch_get_global_queue来获取它们`dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)`，第一个参数是队列的优先级，分别对应四个全局队列(HIGH、DEFAULT、LOW、BACKGROUND)，第二个参数目前系统保留，设置为0即可。
	* 主队列(Main dispatch queue)：主队列是一个特殊的队列，它是系统预定义的运行在主线程的一个Dispatch Queue。可以通过dispatch_get_main_queue来获取唯一的主队列。主队列一般运行一些需要与主线程同步的一些短时任务。
3. 获取当前队列：可以通过dispatch_get_current_queue()获取运行时的队列，如果在队列执行任务中调用，返回执行此任务的队列；如果在主线程中调用，将返回主队列；如果在一般线程中调用，返回DISPATCH_QUEUE_PRIORITY_DEFAULT全局队列。
4. 在队列中运行任务：你可以随时向一个队列中添加一个新任务，只需要调用dispatch_async即可`dispatch_async(aQueue, ^{});`，dispatch_async中的任务是异步执行的，就是说dispatch_async添加任务到执行队列后会立刻返回，而不会等待任务执行完成。然而，必要的话，你也可以调用dispatch_sync来同步的执行一个任务，dispatch_sync会阻塞当前线程直到提交的任务完全执行完毕。
5. 内存管理：除了系统预定义的Dispatch Queue，我们自定义的Dispatch Queue需要手动的管理它的内存。dispatch_retain和dispatch_release这两个函数可以控制Dispatch Queue的引用计数(同时可以控制Dispatch Group和Dispatch Source的引用计数)。当Dispatch Queue引用计数变为0后，就会调用finalizer，finalizer是Dispatch Queue销毁前调用的函数，用来清理Dispatch Queue的相关资源。可以用dispatch_set_finalizer_f函数来设置Dispatch Queue的finalizer，这个函数同时可以设置Dispatch Group和Dispatch Source的销毁函数。
6. 上下文环境数据：可以为每个Dispatch Queue设置一个自定义的上下文环境数据，调用dispatch_set_context来实现。同时我们也可以用dispatch_get_context获取这个上下文环境数据，这个函数同时可以设置Dispatch Group和Dispatch Source的上下文环境数据。需要注意的是Dispatch Queue并不保证这个context不会释放，不会对它进行内存管理控制。我们需要自行管理context的内存分配和释放，一般我们分配内存设置context后，可以在finalizer里释放context占有的内存。

#### Dispatch Source
1. Dispatch Source是GCD中监听一些系统事件的一个Dispatch对象，它包括定时器、文件监听、进程监听、Mach port监听等类型。
2. 可以通过dispatch_source_t dispatch_source_create(dispatch_source_type_t type, uintptr_t handle, unsigned long mask, dispatch_queue_t queue)创建一个Dispatch Source，type可以为文件读或写、进程监听等。handle为监听对象的句柄，如果是文件就是文件描述符，如果是进程就是进程ID。mask用来指定一些想要监听的事件，它的意义取决于type。queue指定事件处理的任务队列。
3. 创建好Dispatch Source后，我们要为Dispatch Source设置一个事件处理模块。可以用dispatch_source_set_event_handler(dispatch_source_t source, dispatch_block_t handler)或dispatch_source_set_event_handler_f来设置。
4. 设置好Dispatch Source后就可以调用dispatch_resume来启动监听，如果相应的事件发生就会触发事件处理模块。也可以设置一个取消处理模块dispatch_source_set_cancel_handler(mySource, ^{close(fd);});取消处理模块会在Dispatch Source取消时调用。

	```
	// 自定义创建dispatch timer定时器，每隔一个固定时间处理一下任务
	dispatch_source_t CreateDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
		dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
		if (timer) {
			dispatch_source_set_timer(timer, dispatch_walltime(NULL,  0), interval, leeway);
			dispatch_source_set_event_handler(timer, block);
			dispatch_resume(timer);
		}
		return timer;
	}
	```

#### Dispatch Group
1. 有时候需要等待几个任务处理完毕后才能进行下一步操作，这时就需要用到Dispatch Group(类似thread join)。我们可以把若干个任务放到一个Dispatch Group中：
	```
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_group_t group = dispatch_group_create();
	dispatch_group_async(group, queue, ^{
		// do some asynchronous work
	});
	
	```
2. dispatch_group_async和dispatch_async一样，会把任务放到queue中执行，不过它比dispatch_async多做了一步操作就是把这个任务和group相关联。
3. 把一些任务放到Dispatch Group后，我们就可以调用dispatch_group_wait来等待这些任务完成。若任务已经全部完成或为空，则直接返回，否则等待所有任务完成后返回(注意：返回后group会清空)。
	```
	dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
	// do some work after
	dispatch_release(group);
	```
	
####	Dispatch信号量
1. 信号量就是一些有限可数资源。比如打印机，假如系统有2台打印机，但同时有5个任务要使用打印机，那么只能有2个任务能同时进行打印，剩下3个要等待这2个任务打印完。那么程序工作过程应该是：任务首先获取打印机资源(dispatch_semaphore_wait)，如果没有打印机可用了就要等待，直到其他任务用完这个打印机。当任务获取到打印机，就开始执行打印任务。任务用完打印机工作后，就必须把占用的打印机释放(dispatch_semaphore_signal)，以便其他任务可以接着打印。
2. 信号量必须在资源使用之前调用dispatch_semaphore_create创建，而且只创建一次，RESOURCE_SIZE是可用资源的总数。使用资源时dispatch_semaphore_wait将资源的可用数减少一个，如果当前没有可用资源了，将会等待直到其他线程回收资源，即调用dispatch_semaphore_signal让可用资源增加。用完资源后调用dispatch_semaphore_signal回收可利用资源，资源可用数将增加一个。

	```
	// 创建资源的信号量，只创建一次，比如2台打印机，那么RESOURCE_SIZE为2。
	dispatch_semaphore_t sema = dispatch_semaphore_create(RESOURCE_SIZE);
	// 如果任务使用一个资源是，使用前调用dispatch_semaphore_wait，用完后dispatch_semaphore_signal。
	// 下面代码可能在多个线程中调用多次
	dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	// do some work here, the work will use one resource
	dispatch_semaphore_signal(sema);
	```
3. 如果是生产者-消费者模式的话，RESOURCE_SIZE可能最初为0，那么生产者将调用dispatch_semaphore_signal来产生一个单位的资源，消费者调用dispatch_semaphore_wait来消费(减少)一个单位的资源。当资源不足时，消费者会一直等待到资源数大于0，即生产者生成新的资源。

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
2. Dispatch Group。
3. Dispatch信号量。
	
#### cocoa常见多线程实现，多线程安全解决方法及多线程安全控制
1. 只在主线程中刷新访问UI。
2. 若要防止资源抢夺，得用synchronized进行加锁保护。
3. 若异步操作要保证线程安全等问题，尽量使用GCD(有些函数默认安全)。

#### GCD内部实现
1. ios和OS X的核心是XNU内核，GCD是基于XNU内核实现。
2. GCD的API全部在libdispatch库中。
3. GCD的底层实现主要有Dispatch Queue(管理block)和Dispatch Source(处理事件)。

#### NSOperationQueue与GCD区别
1. GCD是纯C语言的API，NSOperationQueue是基于GCD的OC版本封装。
2. GCD只支持FIFO的队列，NSOperationQueue可以很方便地调整执行顺序、设置最大并发数量。
3. NSOperationQueue可以轻松在Operation间设置依赖关系，而GCD需要写很多代码才能实现。
4. NSOperationQueue支持KVO，可以监测operation是否正在执行(isExecuted)、是否结束(isFinished)、是否取消(isCanceld).
5. GCD的执行速度比NSOperationQueue快。
6. 任务间互相不太依赖推荐使用GCD(苹果专门为GCD做了性能上的优化)；任务间有依赖或要监听任务的执行情况则推荐使用NSOperationQueue。






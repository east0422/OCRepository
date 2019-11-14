# GCD

#### GCD内部实现
1. iOS和OS X的核心是XNU内核，GCD是基于XNU内核实现。
2. GCD的API全部在libdispatch库中。
3. GCD的底层实现主要有Dispatch Queue(管理block)和Dispatch Source(处理事件-MACH端口发送，MACH端口接收，检测与进程相关事件等10种事件)。

#### GCD的queue和main queue中执行的代码一定在main thread吗
1. 对于queue中所执行的代码不一定在main thread中。如果queue是在主线程中创建的，那么所执行的代码就是在主线程中执行。如果是在子线程中创建的，那么就不会在main thread中执行。
2. 对于main queue就是在主线程中，因此一定会在主线程中执行。获取main queue就可以了，不需要我们创建，获取方式通过调用方法dispatch_get_main_queue()来获取。

#### Dispatch Queue
1. Dispatch Queue是一个任务执行队列，可以让你异步或同步地执行多个Block或函数。Dispatch Queue是FIFO，即先入队的任务总会先执行。
2. 三种类型
	* 串行队列(Serial dispatch queue)：一次只能处理一个任务，可以由用户调用`dipatch_queue_create("come.example.MyQueue", NULL)`创建，第一个参数是串行队列标识，一般用反转域名的格式表示以防冲突，第二个参数是queue的类型，设为NULL时默认是DISPATCH_QUEUE_SERIAL，将创建串行队列，在必要情况下，你可以将其设置为DISPATCH_QUEUE_CONCURRENT来创建自定义并行队列。
	* 并发队列(Concurrent dispatch queue)：可以同时处理多个任务，在不得已的情况下可以用dispatch_queue_create创建，但一般我们都要用系统预定义的并行队列，即全局队列(Global Concurrent Dispatch Queues)。目前系统预定义了四个不同运行优先级的全局队列，我们可以通过dispatch_get_global_queue来获取它们`dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)`，第一个参数是队列的优先级，分别对应四个全局队列(HIGH、DEFAULT、LOW、BACKGROUND)，第二个参数目前系统保留，设置为0即可。
	* 主队列(Main dispatch queue)：主队列是一个特殊的队列，它是系统预定义的运行在主线程的一个Dispatch Queue。可以通过dispatch_get_main_queue来获取唯一的主队列。是个串行队列，一般运行一些需要与主线程同步的一些短时任务和更新UI。
3. 获取当前队列：可以通过dispatch_get_current_queue()获取运行时的队列，如果在队列执行任务中调用，返回执行此任务的队列；如果在主线程中调用，将返回主队列；如果在一般线程中调用，返回DISPATCH_QUEUE_PRIORITY_DEFAULT全局队列。
4. 在队列中运行任务：你可以随时向一个队列中添加一个新任务，只需要调用dispatch_async即可`dispatch_async(aQueue, ^{});`，dispatch_async中的任务是异步执行的，就是说dispatch_async添加任务到执行队列后会立刻返回，而不会等待任务执行完成。然而，必要的话，你也可以调用dispatch_sync来同步的执行一个任务，dispatch_sync会阻塞当前线程直到提交的任务完全执行完毕。
5. 内存管理：除了系统预定义的Dispatch Queue，我们自定义的Dispatch Queue需要手动的管理它的内存。dispatch_retain和dispatch_release这两个函数可以控制Dispatch Queue的引用计数(同时可以控制Dispatch Group和Dispatch Source的引用计数)。当Dispatch Queue引用计数变为0后，就会调用finalizer，finalizer是Dispatch Queue销毁前调用的函数，用来清理Dispatch Queue的相关资源。可以用dispatch_set_finalizer_f函数来设置Dispatch Queue的finalizer，这个函数同时可以设置Dispatch Group和Dispatch Source的销毁函数。
6. 上下文环境数据：可以为每个Dispatch Queue设置一个自定义的上下文环境数据，调用dispatch_set_context来实现。同时我们也可以用dispatch_get_context获取这个上下文环境数据，这个函数同时可以设置Dispatch Group和Dispatch Source的上下文环境数据。需要注意的是Dispatch Queue并不保证这个context不会释放，不会对它进行内存管理控制。我们需要自行管理context的内存分配和释放，一般我们分配内存设置context后，可以在finalizer里释放context占有的内存。
7. dispatch_barrier任务
	* 在同一个并行队列中，有多个线程在执行多个任务，在这个并行队列中有一个dispatch_barrier任务。那么所有在这个dispatch_barrier之后的任务总会等待barrier之前的所有任务结束后才会执行。
	* dispatch_barrier_sync会在主线程中执行队列中的任务，它会阻塞其它任务直到barrier中执行完毕。
	* dispatch_barrier_async会开辟一条新的线程执行其中的任务，不会阻塞当前线程，但其他队列任务(dispatch)是在它执行完毕后才执行。
	* barrier常和并行队列配合而不和串行队列配合是因为和串行队列配合完全没有意义。barrier的目的是为了在某种情况下，同一个队列中一些并发任务必须在另一些并发任务之后执行，所以需要一个类似于拦截的功能，迫使后执行的任务必须等待。而串行队列中的所有任务本身就是按照顺序执行的，没必要使用拦截功能。
	* 在global queue中使用barrier没有意义。因为barrier实现的基本条件是要写在同一队列中(例如，创建两个并行队列，在一个队列中插入了一个barrier任务，不可能期待他可以在第二个队列中生效)，而每一次使用global queue系统分配给你的可能是不同的并行队列，在其中插入一个barrier任务没有意义。

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



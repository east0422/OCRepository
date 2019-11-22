# NSOperation


#### NSOperation
1. 抽象类，不能直接使用，需要使用其子类(和核心动画CAAnimation类似)NSInvocationOperation(调用)和NSBlockOperation(块)。
2. NSInvocationOperation和NSBlockOperation没有本质区别，只是后者使用Block的形式组织代码，使用相对方便。
3. NSInvocationOperation在调用start方法后，不会开启新的线程只会在当前线程中执行。
4. NSBlockOperation在调用start方法后，如果操作的任务数大于1就会开辟多条线程(依据需要系统自动开辟线程)执行，等于1时只会在当前线程执行。
5. 一旦操作添加到操作队列(NSOperationQueue)，就回自动异步执行。

#### NSOperationQueue
1. 最大并发数maxConcurrentOperationCount指的不是线程的数量而是同时执行的任务数量。


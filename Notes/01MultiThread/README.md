# 多线程

## 1. 底层实现
Mach是第一个以多线程方式处理任务的系统，因此多线程的底层实现机制是基于Mach的线程。由于Mach级的线程没有提供多线程的基本特征所以开发中很少用Mach级的线程。线程间是独立的。
开发中实现多线程方案：
* C语言的POSIX接口：#include <pthread.h>
* OC的NSThread
* C语言的GCD接口(性能最好代码更精简)
* OC的NSOperation和NSOperationQueue(基于GCD)

## 2. 线程间通信
* NSMachPort
* performSelector:onThread:withObject:waitUntilDone:
* gcd的dispatch_async
* NSOperationQueue与NSOperation

## 3. 如何避免网络地址重复请求
利用字典(请求地址设为key, 请求下载操作设为value, 请求前判断字典中是否有对应的key)

## 4. 执行A、B后再执行C
使用NSOperation和NSOperationQueue相对简单
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
## 5. cocoa常见多线程实现，多线程安全解决方法及多线程安全控制
* 只在主线程中刷新访问UI。
* 若要防止资源抢夺，得用synchronized进行加锁保护。
* 若异步操作要保证线程安全等问题，尽量使用GCD(有些函数默认安全)。

## 6. GCD内部实现
* ios和OS X的核心是XNU内核，GCD是基于XNU内核实现。
* GCD的API全部在libdispatch库中。
* GCD的底层实现主要有Dispatch Queue(管理block)和Dispatch Source(处理事件)。

## 7. NSOperationQueue与GCD区别
* GCD是纯C语言的API，NSOperationQueue是基于GCD的OC版本封装。
* GCD只支持FIFO的队列，NSOperationQueue可以很方便地调整执行顺序、设置最大并发数量。
* NSOperationQueue可以轻松在Operation间设置依赖关系，而GCD需要写很多代码才能实现。
* NSOperationQueue支持KVO，可以监测operation是否正在执行(isExecuted)、是否结束(isFinished)、是否取消(isCanceld).
* GCD的执行速度比NSOperationQueue快。
* 任务间互相不太依赖推荐使用GCD；任务间有依赖或要监听任务的执行情况则推荐使用NSOperationQueue。






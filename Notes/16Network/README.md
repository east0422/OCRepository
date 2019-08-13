# Network网络

#### Reachability
1. 监测联网状态`Reachability *reach = [Reachability     reachabilityWithHostName:@"www.baidu.com"];`
2. 判断reach.currentReachabilityStatus值。
3. 利用通知中心实时监听联网状态

	```
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged) name:kReachabilityChangedNotification object:nil];
	self.reachability = [Reachability reachabilityForInternetConnection];
	[self.reachability startNotifier];
	```

#### NSURLConnection（已被NSURLSession取代）
1. 特点：处理简单网络操作非常简单，但是处理复杂的网络操作就非常繁琐。
2. 下载过程中，没有’进度的跟进’，需要通过代理的方法来处理。
3. 存在内存的峰值，解决方法是接收一点就写入文件一点。
4. NSURLConnection的代理默认是在主线程运行的，需要将其代理移到子线程执行。`[connection setDelegateQueue:[[NSOperationQueue alloc] init]];`
5. 默认下载任务在主线程工作，为避免阻塞UI更新也需要将其移到子线程执行，子线程默认不开启运行循环还需为其开启运行循环`dispatch_async(dispatch_get_global_queue(0, 0), ^{下载操作})`

#### NSURLSession
1. 是iOS7中出现的网络接口，可通过URL将数据下载到内存、文件系统，还可以将据上传到指定URL，也可以在后台完成下载上传。是线程安全的。
2. NSURLSessionConfiguration
 	1. 用于定义和配置NSURLSession对象。每一个NSURLSession对象都可以设置不同的NSURLSessionConfiguration从而满足应用内不同类型的网络请求。
 	2. 三种类型：
  		* defaultSessionConfiguration：默认配置，使用硬盘来存储缓存数据，类似NSURLConnection的标准配置。
  		* ephemeralSessionConfiguration：临时session配置，不会将缓存、cookie等保存在本地，只会存在内存里，所以当程序退出时，所有的数据都会消失。
  		* backgroundSessionConfiguration：后台session配置，与默认配置类似，不同的是会在后台开启另一个线程来处理网络数据。
3. NSURLSessionTask
	1. NSURLSession使用NSURLSessionTask来具体执行网络请求的任务。
	2. 支持网络请求的取消、暂停和恢复，也能获取数据的读取进度。
	3. 三种类型
		* NSURLSessionDataTask：处理一般的NSData数据对象，如通过GET或POST从服务器获取JSON或XML返回等等，但不支持后台获取。
		* NSURLSessionUploadTask：用于PUT上传文件，支持后台上传。
		* NSURLSessionDownloadTask：用于下载文件，支持后台下载。


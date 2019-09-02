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

#### 设计一套大文件(如上百M的视频)下载方案
1. NSURLSession。
2. 支持断点下载，自动记录停止下载时断点的位置。
3. 遵守NSURLSessionDownloadDelegate协议。
4. 使用NSURLSession下载大文件，被下载文件会被自动写入沙盒的临时文件夹tmp中。
5. 下载完毕，通常需要将已下载文件移动其他位置(tmp文件夹中的数据被定时删除)，通常是cache文件夹中。
6. 下载步骤：
	1. 设置下载任务task为成员变量`@property (nonatomic, strong) NSURLSessionDownloadTask *task;`。
	2. 获取NSURLSession对象`NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];`。
	3. 初始化下载任务`self.task = [session downloadTaskWithURL:downloadUrl];`。
	4. 实现代理方法

	```
	/* 每当写入数据到临时文件的时候，就会调用一次该方法，通常在该方法中获取下载进度*/
	- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
		// 计算下载进度
		CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
	}
	/* 任务终止时调用的方法，通常用于断点下载 */
	- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
		// fileOffset: 下载任务中止时的偏移量
	}
	/* 遇到错误的时候调用，error参数只能传递客户端的错误 */
	- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
		// do something
	}
	/* 下载完成的时候调用，需要将文件剪切到可以长期保存的文件夹中 */
	- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
		// 生成文件长期保存的路径
		NSString *file = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
		// 获取文件句柄
		NSFileManager *fileManager = [NSFileManager defaultManager];
		// 通过文件句柄，将文件剪切到文件长期保存的路径
		[fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
	}
	```
	5. 操作任务状态

	```
	/* 开始/继续 下载任务 */
	[self.task resume];
	/* 暂停下载任务 */
	[self.task suspend];
	```



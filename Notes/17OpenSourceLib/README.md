# 第三方开源库

#### SDWebImage
1. 开源地址 [https://github.com/SDWebImage/SDWebImage](https://github.com/SDWebImage/SDWebImage)。
2. 内部实现过程
	1. 入口setImageWithURL:placeholderImage:options:会先把placeholderImage显示，然后SDWebImageManager根据URL开始处理图片。
	2. 进入SDWebImageManager的downloadWithURL:delegate:options:userInfo:，交给SDImageCache从缓存查找图片是否已经下载queryDiskCacheForKey:delegate:userInfo:。
	3. 先从内存图片缓存查找是否有图片，如果内存中已经有图片缓存，SDImageCacheDelegate回调imageCache:didFindImage:forKey:userInfo:到SDWebImageManager。
	4. SDWebImageManagerDelegate回调webImageManager:didFinishWithImage:到UIImageView+WebCache等前端展示图片。
	5. 如果内存缓存中没有，生成NSInvocationOperation添加到队列开始从硬盘查找图片是否已经缓存。
	6. 根据URLKey在硬盘缓存目录下尝试读取图片文件。这一步是在NSOperation进行的操作，所以回主线程进行结果回调notifyDelegate:。
	7. 若上一操作从硬盘读取到了图片，将图片添加到内存缓存中(如果空闲内存过小，会先清空内存缓存)。SDImageCacheDelegate回调imageCache:didFindImage:forKey:userInfo:。进而回调展示图片。
	8. 如果从硬盘缓存目录读取不到图片，说明所有缓存都不存在该图片，需要下载图片，回调imageCache:didNotFindImageForKey:userInfo:。
	9. 共享或重新生成一个下载器SDWebImageDownloader开始下载图片。
	10. 图片下载由NSURLConnection来做，实现相关delegate来判断图片下载中、下载完成和下载失败。
	11. connection:didReceiveData:中利用ImageIO做了按图片下载进度加载效果。
	12. connectionDidFinishLoading:数据下载完成后交给SDWebImageDecoder做图片解码处理。
	13. 图片解码处理在一个NSOperationQueue完成，不会拖慢主线程UI。如果有需要对下载的图片进行二次处理，最好也在这里完成，效率会好很多。
	14. 在主线程notifyDelegateOnMainThreadWithInfo:宣告解码完成，imageDecoder:didFinishDecodingImage:userInfo:回调给SDWebImageManager告知图片下载完成。
	15. 通知所有的downloadDelegates下载完成，回调给需要的地方展示图片。
	16. 将图片保存到SDImageCache中，内存缓存和硬盘缓存同时保存。写文件到硬盘也在以单独NSInvocationOperation完成，避免拖慢主线程。
	17. SDImageCache在初始化的时候会注册一些消息通知，在内存警告或退到后台的时候清理内存图片缓存，应用结束的时候清理过期图片。
	18. SDWebImage也提供了UIButton+WebCache和MKAnnotationView+WebCache，方便使用。
	19. SDWebImagePrefetcher可以预先下载图片，方面后续使用。
3. 缓存机制(图片缓存、内存缓存、沙盒缓存、操作缓存，下述以tableViewController为例)。
	1. 每次cell需要显示，都需要重新调用-(UITableViewCell)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{}方法。
	2. 每次调用tableView显示行的数据源方法时，如果需要从网络加载图片，就需要将加载图片这样的耗时操作放在子线程上执行，从网络上下载的图片可以以键值对的形式保存在定义的可变字典中，将每张图片的唯一路径作为键，将从网络下载下来的图片作为值，保存在内存缓存中，这样每次滑动tableView，cell重用时就直接判断内存缓存中有没有需要的图片，如果有就不需要再次下载，在没有出现内存警告或程序员手动清理内存缓存时，就直接从内存缓存中获取图片。
	3. 为了每次退出程序再次进入程序时，不浪费用户流量，需要将第一次进入程序时加载的图片保存在本地沙盒缓存文件中，在沙盒中保存的图片数据没有被改变之前，下次开启程序就直接从沙盒的缓存文件中读取需要显示的图片，并将沙盒缓存文件夹(Cache)中保存的图片保存到内存缓存中，这样用户每次滑动tableView Cell重用时直接从内存缓存中读取而不是从沙盒中读取，节约时间。
	 
#### AFNetworking
1. 开源地址 [https://github.com/AFNetworking/AFNetworking](https://github.com/AFNetworking/AFNetworking)。
2. 底层原理分析(AFNetworking主要是对NSURLSession和NSURLCollection(iOS9.0废弃)的封装，其中主要有以下类)
	1. AFHTTPRequestOperationManager:内部封装的是NSURLConnection，负责发送网络请求，使用较多的一个类(3.0废弃)。
	2. AFHTTPSessionManager:内部封装的是NSURLSession，负责发送网络请求，使用较多的一个类。
	3. AFNetworkReachabilityManager:实时监测网络状态的工具类，当前的网络环境发生改变之后，这个工具类就可以监测到。
	4. AFSecurityPolicy:网络安全的工具类，主要是针对HTTPS服务。
	5. AFURLRequestSerialization:序列化工具类，基类。上传的数据转换成JSON格式使用AFJSONRequestSerializer。
	6. AFURLResponseSerialization:反序列化工具类，基类。
	7. AFJSONResponseSerializer:JSON解析器，默认的解析器。
	8. AFXMLParserResponseSerializer:XML解析器。
	9. AFHTTPResponseSerializer:万能解析器，JSON和XML之外的数据类型，直接返回二进制数据，对服务器返回的数据不做任何处理。
3. 断点续传主要思路
	1. 检查服务器文件信息。
	2. 检查本地文件。
	3. 如果比服务器文件小，断点续传，利用HTTP请求头的Range实现断点续传。
	4. 如果比服务器文件大，重新下载。
	5. 如果和服务器文件已有，下载完成。 



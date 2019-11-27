# AFNetworking

	 
#### 浅析
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




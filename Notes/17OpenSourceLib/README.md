# 第三方开源库
	
	
#### CocoaPods
1. 通常使用CocoaPods安装管理依赖库。
2. 常用命令有
	1. pod init 初始化Podfile。
	2. pod search name 查找相关框架。
	3. pod install 依照Podfile安装或删除。
3. 1.8版本中将CDN切换为默认spec repo源，并附带一些增强功能，旨在大大加快初始设置和依赖性分析。
	1. 若使用CDN报错CDN: trunk URL couldn't be downloaded，可在Podfile头部加上source 'https://github.com/CocoaPods/Specs.git'指定源。
	2. 使用search不正常或没反应可以使用pod repo remove trunk将trunk源删除。
	3. 通常结合上面两个，删除trunk源，在Podfile中指定master源(因为默认是trunk源)。

#### SDWebImage
	下载缓存网络图片
	 
#### AFNetworking
	网络请求交互

#### RAC(ReactiveObjC)
	函数响应式编程
	


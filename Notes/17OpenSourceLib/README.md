# 第三方开源库
	
	
#### CocoaPods
1. 通常使用CocoaPods安装管理依赖库。
2. 常用命令有
	1. sudo gem install cocoapods安装cocoapods。
	2. pod setup将远程索引库下载到本地。
	3. pod init 初始化Podfile。
	4. pod search name 查找相关框架。
	5. pod install(安装或删除)/update(更新)/outdated(查看是否有新库)。
	6. install和update命令默认会先将远程索引库更新到本地，若不需要更新后面可加参数--no-repo-update。
	7. pod lib create mylib从远程下载模版创建自己库。
3. 1.8版本中将CDN切换为默认spec repo源，并附带一些增强功能，旨在大大加快初始设置和依赖性分析。
	1. 若使用CDN报错CDN: trunk URL couldn't be downloaded，可在Podfile头部加上source 'https://github.com/CocoaPods/Specs.git'指定源。
	2. 使用search不正常或没反应可以使用pod repo remove trunk将trunk源删除。
	3. 通常结合上面两个，删除trunk源，在Podfile中指定master源(因为默认是trunk源)。
	4. Podfile.lock需要加入到版本管理中，锁定各依赖库版本。
	5. resource.sh脚本文件将pods及资源文件拷贝到目标项目中。
	6. 本地索引库位置默认为~/Library/Caches/CocoaPods/search_index.json。

#### SDWebImage
	下载缓存网络图片
	 
#### AFNetworking
	网络请求交互

#### RAC(ReactiveObjC)
	函数响应式编程
	
#### Masonry
	UI自动布局
	


# 文件管理


#### 沙盒结构
1. 每个app应用在手机上都有一个独立的文件夹，相互之间不能访问。
2. Application应用程序包：存放程序源文件，上架前经过数字签名，上架后不可修改。包含所有的资源文件和可执行文件。
3. Documents：常用目录，iCloud备份目录，存放数据，这里不能存缓存文件，否则上架不被通过。保存应用运行时生成的需要持久化的数据，iTunes会自动备份该目录，苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]。
4. tmp：临时文件，保存应用运行时所需的临时数据，使用完毕后再将相应的文件从该目录删除。应用没有运行时，系统也有可能会清除该目录下的文件，iTunes不会同步该目录，iPhone重启时，该目录下的文件会丢失NSTemporaryDirectory。
5. Library：存储程序的默认设置和其他状态信息，iTunes会自动备份该目录[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) firstObject];。
6. Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除。一般存放体积比较大不需要备份，不是特别重要的数据，SDWebImage缓存路径就是这个[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject]。
7. Library/Preferences：保存应用的所有偏好设置，iOS的Settings（设置）应用会在该目录中查找应用的设置信息，iTunes会自动备份该目录。

#### App Bundle包含文件
1. Info.plist: 此文件包含了应用程序的配置信息，系统依赖此文件以获取应用程序的相关信息。
2. 可执行文件: 此文件包含应用程序的入口和通过静态连接到应用程序target的代码。
3. 资源文件: 图片，声音文件一类的。
4. 其他: 可以嵌入定制的数据资源。

#### 文件读写
1. 直接使用NSString的writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:写入文件。
2. 直接使用NSString的stringWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)enc error:读取文件内容。


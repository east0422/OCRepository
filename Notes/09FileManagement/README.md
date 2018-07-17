# 文件管理

## 1. 沙盒
* 每个app应用在手机上都有一个独立的文件夹，相互之间不能访问。
* 应用程序包：包含所有的资源文件和可执行文件。
* Document：保存应用运行时生成的需要持久化的数据，iTunes会自动备份该目录，苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]。
* tmp：临时文件，保存应用运行时所需的临时数据，使用完毕后再将相应的文件从该目录删除。应用没有运行时，系统也有可能会清除该目录下的文件，iTunes不会同步该目录，iPhone重启时，该目录下的文件会丢失NSTemporaryDirectory。
* Library：存储程序的默认设置和其他状态信息，iTunes会自动备份该目录[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) firstObject];。
* Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除。一般存放体积比较大，不是特别重要的资源[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject]。
* Library/Preferences：保存应用的所有偏好设置，iOS的Settings（设置）应用会在该目录中查找应用的设置信息，iTunes会自动备份该目录。

## 2. NSFileManager
* 用于文件或目录的操作(创建、复制、剪切、删除、获取属性、获取子目录)。
* 单例模式模式可通过defaultManager获取。
* contentsAtPath:(NSString *)path获取路径文件内容。
* createFileAtPath:(NSString *)path contents:(nullable NSData *)data attributes:以指定内容创建一个文件。
* copyItemAtPath:(NSString *)srcPath toPath:(NSString *)destPath error:复制文件，若复制路径中所包含目录不存在则复制失败。
* moveItemAtPath:(NSString *)srcPath toPath:(NSString *)destPath error:将一个文件移动到另一个位置也就是所谓的剪切。
* 若目标文件已存在即使内容不同复制和剪切都会失败，且不会覆盖原来文件。
* removeItemAtPath:(NSString *)path error:删除文件。
* attributesOfItemAtPath:(NSString *)path error:获取文件属性。
* subpathsAtPath:(NSString *)path递归获取所有子目录文件。

## 3. 文件读写
* 直接使用NSString的writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:写入文件。
* 直接使用NSString的stringWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)enc error:读取文件内容。


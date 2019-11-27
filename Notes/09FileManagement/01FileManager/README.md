# NSFileManager


#### 简述
1. 用于文件或目录的操作(创建、复制、剪切、删除、获取属性、获取子目录)。
2. 单例模式模式可通过defaultManager获取。
3. contentsAtPath:(NSString *)path获取路径文件内容。
4. createFileAtPath:(NSString *)path contents:(nullable NSData *)data attributes:以指定内容创建一个文件。
5. copyItemAtPath:(NSString *)srcPath toPath:(NSString *)destPath error:复制文件，若复制路径中所包含目录不存在则复制失败。
6. moveItemAtPath:(NSString *)srcPath toPath:(NSString *)destPath error:将一个文件移动到另一个位置也就是所谓的剪切。
7. 若目标文件已存在即使内容不同复制和剪切都会失败，且不会覆盖原来文件。
8. removeItemAtPath:(NSString *)path error:删除文件。
9. attributesOfItemAtPath:(NSString *)path error:获取文件属性。
10. subpathsAtPath:(NSString *)path递归获取所有子目录文件。




# 性能优化

#### 查看app启动时间
1. Edit Scheme -> Arguments -> Environment Variables增加字段DYLD_PRINT_STATISTICS值设为1可得出dyld耗时信息。
2. 在main.m中定义全局变量CFAbsoluteTime startTime在main方法中初始化startTime=CFAbsoluteTimeGetCurrent()；在AppDelegate.m中使用extern CFAbsoluteTime startTime声明外部全局变量，在didFinishLaunchingWithOptions:方法中获取当前时间CFAbsoluteTimeGetCurrent再减去startTime可得出main函数后Application启动时间。
3. 使用Time Profile工具。

#### UITableview
1. 正确使用reuseIdentifier来复用单元格。
2. 尽量使用不透明的视图，不透明的视图可以提高渲染的速度，可将cell及其子视图的opaque属性设为YES(默认值)。单元格中尽量少使用动画效果，最好不要使用insertRowsAtIndexPaths:withRowAnimation:方法，而是直接调用reloadData方法。
3. 图片加载使用异步加载，并且设置图片加载的并发数。
4. 滑动时不加载图片，停止滑动开始加载。滚动很快时只加载目标范围内的cell, 按需加载极大的提高流畅度。
5. 文字、图片可以直接drawInRect绘制。
6. 减少reloadData全部cell，只reloadRowsAtIndexPaths。
7. 提前计算出高度并缓存，因为heightForRowAtIndexPath:是调用最频繁的方法。cell高度固定的话直接用cell.rowHeight设置高度。
8. 尽量少用addView给cell动态添加view，可以初始化时就添加然后通过hide来控制是否显示。
9. 若cell显示内容来自web，使用异步加载并缓存请求结果。
10. 当从服务端下载相关附件时，可以通过gzip/zip压缩后再下载，使得内存更小，下载速度也更快。
11. 使用shadowPath来画阴影，减少subViews的数量。
12. 尽量不使用cellForRowAtIndexPath:，如果你需要用到它，只用一次然后缓存结果。
13. 使用正确的数据结构来存储数据。
14. 使用rowHeight，sectionFooterHeight和sectionHeaderHeight来设定固定的高，不要请求delegate。

#### UIImageView
1. 在Image Views中调整图片大小。如果要在UIImageView中显示一张来自bundle的图片，你应保证图片的大小和UIImageView的大小相同。在运行中缩放图片是很耗费资源的，特别是UIImageView嵌套在UIScrollView中的情况下。
2. 如果图片是从远端服务加载的你不能控制图片大小，比如在下载前调整到合适大小的话，你可以在下载完成后，最好是用background thread，缩放一次，然后在UIImageView中使用缩放后的图片。

#### UIImage加载图片
1. imageNamed默认加载图片成功后会在内存中缓存图片，这个方法用一个指定的名字在系统缓存中查找并返回一个图片对象。如果缓存中没有找到相应的图片对象，则从指定地方加载图片然后缓存对象并返回这个图片对象。
2. imageWithContentsOfFile则仅只加载图片不缓存。加载一张大图并且使用一次，用imageWithContentsOfFile是最好，这样CPU不需要做缓存节约时间。

#### 使用场景
1. 不要在viewWillAppear中做费时的操作，viewWillAppear:在view显示之前被调用，出于效率考虑，方法中不要处理复杂费时操作。在该方法中可设置view的显示属性之类的简单事情(比如背景色、字体等)，否则，会明显感觉到view有卡顿或延迟。
2. 在正确的地方使用reuseIdentifier:tableView，用tableView:cellForRowAtIndexPath:为rows分配cells时，它的数据应该重用自UITableViewCell。
3. 尽量把views设置为不透明：如果你有透明的views应该设置它们的opaque属性为YES。系统用一个最优的方式渲染这些views。这个简单的属性在IB或代码里都可以设定。
4. 避免过于庞大的XIB:尽量简单的为每个Controller配置一个单独的XIB，尽可能把一个View Controller的view层次结构分散到单独的XIB中去，当你加载一个引用了图片或声音资源的nib时，nib加载代码会把图片和声音文件写进内存。
5. 不要阻塞主线程：永远不要使主线程承担过多。因为UIKit在主线程上做所有工作，渲染，管理触摸反应，回应输入等都需要在它上面完成，大部分阻碍主进程的情形是你的app在做一些牵涉到读写外部资源的I/O操作，比如存储或者网络。

	```
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		// 选择一个子线程来执行耗时操作
		dispatch_async(dispatch_get_main_queue(), ^{
			// 返回主线程更新UI
		});	
	});
	```

#### 选择正确的数据存储选项
1. NSUserDefaults很便捷，但是它只适用于小数据，比如一些简单的布尔型的设置选项，再大点你就要考虑其它方式了。
2. XML这种结构化档案需要读取整个文件到内存里去解析，这样是很不经济的。使用SAX又是一个很麻烦的事情。
3. NSCoding也需要读写文件，故也有以上问题。
4. 在这种应用场景下，使用SQLite或Core Data比较好，用特定的查询语句就能只加载你需要的对象。在性能层面来讲，SQLite和Core Data很相似，他们的不同在于具体适用方法。Core Data代表一个对象的graph model，但SQLite就是一个DBMS。Apple在一般情况下建议使用Core Data，若有理由不使用它，那就使用更加底层的SQLite吧(可以用FMDB这个库来简化SQLite的操作)。

#### 应用瘦身App thinning
1. 自iOS9发布的新特性，它能对Apple Store和操作系统进行优化，它根据用户的具体设备型号，在保证应用特性完整的前提下，尽可能地压缩和减少应用程序安装包的体积，也就是尽可能减少应用程序对用户设备内存的占用，从而减少用户下载应用程序的负担。
2. App thinning主要有三种方法：
	* Slicing，开发者将完整的应用安装包发布到apple store之后，apple store会根据下载用户的目标设备型号创建相应的应用变体(variants of the app bundle)。这些变体只包含可执行的结构和资源等必要部分，而不需要让用户下载开发者提供的完整安装包。
	* Bitcode(位码)，通过消除针对不同架构的优化，以及只下载相关优化，从而使下载变得更小。位码是编译程序的中间表示形式。上传到iTunes Connect中包含位码的应用程序将被编译并链接到商店，包括位码将允许苹果在未来重新优化你的应用程序二进制而不需要提交一个新的应用程序版本到App Store。Xcode默认启用Bitcode，但有些第三方SDK可能会要求关闭Bitcode，是否开启该属性需灵活处理。Xcode隐藏了默认情况下在构建期间生成的符号，因此苹果无法读取这些符号，只有当你的应用程序上传到iTunes Connect时包含符号，这些符号才会被发送到苹果。你必须包含一些符号来接收来自苹果的崩溃报告。
	* On Demand Resources(随机应变资源)，按需资源是一种资源(例如，图像和声音等)，你可以使用标记关键字和组内请求，商店托管Apple服务器上的资源并为您管理下载，按需资源可实现更快的下载速度和更小的应用程序大小，从而改善首次发布体验(例如，游戏应用可以将资源划分为游戏机杯，并且仅当应用预期用户将移动到该级别时猜请求下一级资源。同样，只有当用户购买相应的应用购买时，应用才能请求应用内购买资源)。当不再需要资源并且磁盘空间不足时，操作系统会清除按需资源，如果您导出应用程序以在商店外进行测试或者分发，则必须自己托管按需资源，注意不支持可执行的按需资源。

#### 选择正确的Collection
1. Arrays：有序的一组值。使用index来lookup很快，使用value lookup很慢，插入/删除很慢。
2. Dictionaries： 存储键值对。用键来查找比较快。
3. Sets：无序的一组值。用值来查找很快，插入/删除很快。

#### 打开gzip压缩
1. app可能大量依赖于服务器资源，问题是我们的目标是移动设备，因此你就不能指望网络状况有多好。减小文档的一个方式就是在服务端和你的app中打开gzip。这对于文字这种能有更高压缩率的数据来说会有更显著的效用(iOS已经在NSURLConnection中默认支持了gzip压缩，当然AFNetworking这些基于它的框架亦然)。

#### 重用和延迟加载views
1. 更多的view意味着更多的渲染，也就是更多的CPU和内存消耗，对于那种嵌套了很多view在UIScrollView里边的app更是如此。
2. 用到的技巧就是模仿UITableView和UICollectionView的操作：不要一次创建所有的subview，而是当需要时才创建，当它们完成了使命，把他们放进一个可重用的队列中。这样的话你就只需要在滚动发生时创建你的views，避免了不划算的内存分配。

#### 缓存Cache
1. 一个极好的原则就是，缓存所需要的，也就是那些不大可能改变但是需要经常读取的东西。
2. 常缓存的有远端服务器的响应，图片，甚至计算结果(比如UITableView的行高)等。
3. NSCache和NSDictionary类似，不同的是系统回收内存的时候它会自动删除它的内容。

#### 正确设定背景图片
1. 全屏背景图，在view中添加一个UIImageView作为一个子View。
2. 只是某个小的view的背景图，你就需要用UIColor的colorWithPatternImage来做了，它会更快地渲染也不会花费很多内存。

#### 加速启动时间
1. 快速打开app是很重要的，特别是用户第一次打开它时。
2. 能做的就是使它尽可能做更多的异步任务，比如加载远端或者数据库数据，解析数据。避免过于庞大的XIB，因为他们是在主线程上加载的。所以尽量使用没有这个问题的Storyboard。
3. 一定要把设备从Xcode断开来测试启动速度。

#### 平时如何对代码进行性能优化
1. 利用性能分析工具检测，包括静态Analyze工具，以及运行时Profile工具，通过Xcode工具栏中Product->Profile可以启动。
2. 比如测试程序启动运行时间，当点击Time Profiler应用程序开始运行后，就能获取到整个应用程序运行消耗时间分布和百分比。为了保证数据分析在统一使用场景真实，需要注意一定要使用真机，因为此时模拟器是运行在Mac上，二Mac上的CPU往往比iOS设备要快。
3. 为了防止一个应用占用过多的系统资源，开发iOS的苹果工程师门设计了一个“看门狗”的机制。在不同场景下，“看门狗”会监测应用的性能。如果超出了该场景所规定的运行时间，“看门狗”就会强制终结这个应用的进程。开发者们在crashlog里面会看到诸如0x8badf00d这样的错误代码。




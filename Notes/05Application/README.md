# 应用程序

## 1. NSRunLoop实现机制及在多线程中使用
* 控制NSRunLoop里面线程的执行和休眠，节省CPU资源，提高程序性能。在有事情做的时候使当前NSRunLoop控制的线程工作，没有事情做时就让当前NSRunLoop控制的线程休眠。
* NSRunLoop就是一直在循环检测保持程序的持续运行，从线程start到线程end。处理各种事件(手势、定时器、Selector等)。
* runloop和线程是一对一的关系，主线程的runloop一旦销毁程序就退出了，而在ARC下，系统会在子线程完成的时候销毁掉这个子线程，因此子线程的runloop也就跟着自动销毁了。
* runloopmode是一个集合，包括监听：事件源，定时器以及需要通知的runloop observers。
* 只有在创建次线程时才需要运行run loop。对于程序的主线程而言，run loop是关键部分。UIApplicationMain会建立应用的main loop并启动，所以即使有return，但永远都不会返回。
* 在多线程中需要判断是否需要run loop。若需要run loop，则你要负责配置run loop并启动。不需要在任何情况下都去启动run loop(比如使用线程去处理一个预先定义好的耗时极长的任务时就可以不启动run loop)。run loop只在要和线程有交互时才需要。

## 2. APP启动过程
* main函数。
* UIApplicationMain创建UIApplication对象和delegate对象。
* 有storyboard时根据Info.plist中设置文件名加载storyboard并创建UIWindow。
* 无storyboard时，delegate对象开始处理(监听)系统事件，程序启动完毕的时候会调用代理的application:didFinishLaunchingWithOptions:方法并在方法中创建UIWindow。
* 创建和设置UIWindow的rootViewController。
* 显示窗口。

## 3. 本地通知和远程推送通知
* 本地通知和远程推送通知都可以向不在前台运行的应用发送消息，这种消息可能是即将发生的事件，也可能是服务器的新数据。他们在程序界面的显示效果相同，都能显示为一段警告信息或应用程序图标上的徽章。基本目的都是让应用程序能够通知用户某些事情而不需要应用程序在前台运行。
* 本地通知有本应用富足调用，只能从当前设备上的iOS发出，而远程推送通知由远程服务器上的程序发送到APNS，再由APNS把消息推送至设备上的程序。







# Runloop运行循环


## 1. 基本作用
* 保持程序的持续运行不退出，本质是一个死循环.
* 处理app中各种事件(触摸、定时器、selector等).
* 节省cpu资源，提高程序性能：该做事时做事，该休息时休息.
* 每个线程都有唯一的一个与之对应的runloop对象，UIApplicationMain函数内部启动了一个与主线程相关联的runloop，故常说主线程的runloop自动创建好了而子线程的runloop需要主动创建；runloop在首次获取时创建在线程结束时销毁.
* NSDefaultRunLoopMode模式处理时钟、网络事件， NSTimer的scheduledTimerWithTimeInterval默认加到该模式的runloop中；NSTrackingRunLoopMode用户交互模式；NSRunLoopCommonModes占位模式，既能处理用户交互、UI事件也能处理时钟定时器等，相当于另外两种模式的结合体.
* 一次runLoop循环需要绘制屏幕上所有的点.

## 2. 注意点
* NSRunLoopCommonModes模式的runloop中若有耗时操作则可能会引起UI的卡顿，解决方法是使用runloop分拆耗时操作.


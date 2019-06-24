# Runloop运行循环


#### 定义及作用
1. 保持程序的持续运行不退出，本质是一个死循环。
2. 处理app中各种事件(触摸、定时器、selector等)。
3. 节省cpu资源，提高程序性能：该做事时做事，该休息时休息。
4. 每个线程都有唯一的一个与之对应的runloop对象用来循环处理输入事件(来自Input sources的异步事件和来自Timer sources的同步事件)，UIApplicationMain函数内部启动了一个与主线程相关联的runloop，故常说主线程的runloop自动创建好了而子线程的runloop需要主动创建；runloop在首次获取时创建在线程结束时销毁。
5. NSDefaultRunLoopMode模式处理时钟、网络事件， NSTimer的scheduledTimerWithTimeInterval默认加到该模式的runloop中；NSTrackingRunLoopMode用户交互模式；NSRunLoopCommonModes占位模式，既能处理用户交互、UI事件也能处理时钟定时器等，相当于另外两种模式的结合体。
6. 一次runLoop循环需要绘制屏幕上所有的点。
7. 每个run loop可运行在不同的模式下，一个run loop mode是一个集合，其中包含其监听的若干输入事件源，定时器，以及在事件发生时需要通知的run loop observers。

#### NSRunLoop
1. NSRunLoop对象是OC对象，是对CFRunLoopRef的封装，可以通过getCFRunLoop方法获取其对应的CFRunLoopRef对象。NSRunLoop不是线程安全的，但CFRunLoopRef是线程安全的。
2. NSRunLoop对象是一序列RunLoopMode的集合，每个mode包括有这个模式下所有的Source源、Timer源和观察者。每次RunLoop调用的时候都只能调用其中的一个mode，接收这个mode下的源，通知这个mode下的观察者。这样设计的主要目的是为了隔离各个模式下的源和观察者，使其不相互影响。
3. 每次运行RunLoop，内部都会处理之前没有处理的消息，并且在各个阶段通知相应的观察者。内部基本流程大致步骤如下：
	1. 通知观察者RunLoop启动。
	2. 通知观察者即将处理Timer。
	3. 通知观察者即将处理Source0。
	4. 触发Source0回调处理Source0。
	5. 如果有Source1(基于port)处于ready状态，直接处理该Source1然后跳转到==(9)==去处理消息。
	6. 如果没有待处理消息，则通知观察者RunLoop所在线程即将进入休眠。
	7. 休眠前，RunLoop会添加一个dispatchPort，底层调用mach_msg接收mach_port的消息。线程进入休眠，直到下面某个事件触发唤醒线程：
		* 基于port的Source1事件到达。
		* Timer事件到达。
		* 手动唤醒。
		* RunLoop启动时设置的最大超时时间到了。
	8. 唤醒后，将休眠前添加的dispatchPort移除，并通知观察者RunLoop已经被唤醒。
	9. 通过handle_msg处理消息。
	10. 如果消息是Timer类型，则触发该Timer的回调。
	11. 如果消息是dispatch到main_queue的block执行block。
	12. 如果消息是Source1类型，则处理Source1回调。
	13. 以下条件中有满足时退出循环，否则跳回==(2)==继续循环。
		* 事件处理完毕而且启动RunLoop时参数设置为一次性执行。
		* 启动RunLoop时设置的最大运行时间到期。
		* RunLoop被外部调用强行停止。
		* 启动RunLoop的mode item为空。
	14. 上一步退出循环后退出RunLoop，通知观察者RunLoop退出。

#### RunLoopMode
1. Default模式：NSDefaultRunLoopMode(Cocoa)，kCFRunLoopDefaultMode(Core Foundation)几乎包含了所有输入源(NSConnection除外)，一般情况下应使用此模式。
2. Connection模式：NSConnectionReplyMode(Cocoa)处理NSConnection对象相关事件，系统内部使用，用户基本不会使用。
3. Modal模式：NSModalPanelRunLoopMode(Cocoa)处理modal panels事件
4. Event tracking模式：NSEventTrackingRunLoopMode(Cocoa)，UITrackingRunLoopMode(iOS)在拖动loop或其他user interface tracking loops时处于此种模式下，在此模式下会限制输入事件的处理。手指按住UITableView拖动时就会处于此模式。
5. Common模式：NSRunLoopCommonModes(Cocoa)，kCFRunLoopCommonModes(Core Foundation)这是一个伪模式，其为一组run loop mode的集合，将输入源加入此模式意味着在Common Modes中包含的所有模式都可以处理。在Cocoa应用程序中，默认情况下Common Modes包含default，modal，event tracking。还可以使用CFRunLoopAddCommonMode方法向Common Modes中添加自定义modes。
6. 注意：NSTimer和NSURLConnection默认运行在default mode下，当用户在拖动UITableView处于UITrackingRunLoopMode模式时，NSTimer不能fire，NSURLConnection的数据也无法处理；这种情况下可以在另外的线程中处理定时器事件，可把Timer加入到NSOperation中在另一个线程中调度。或者更改Timer运行的run loop mode，将其加入到UITrackingRunLoopMode或NSRunLoopCommonModes中。

#### CFRunLoopSourceRef(事件源产生的地方)
1. Source0：只包含一个函数指针(回调函数)，不能自动触发，只能手动触发，触发方式是先通过CFRunLoopSourceSignal(source)将这个Source标记为待处理，然后再调用CFRunLoopWakeUp(runloop)来唤醒RunLoop处理这个事件。
2. Source1：基于port的Source源，包含一个port和一个函数指针(回调方法)。该Source源可通过内核和其他线程相互发送消息，而且可以主动唤醒RunLoop。

#### CFRunLoopTimerRef
1. CFRunLoopTimerRef是基于事件的触发器，其中包含一段时间长度、延期容忍度和一个函数指针(回调方法)。当其加入到RunLoop中时，RunLoop会注册一个时间点，当到达这个时间点后会触发对应的事件。

#### performSEL
1. performSEL其实和NSTimer一样，是对CFRunLoopTimerRef的封装。因此，当调用performSelector:afterDelay:后，实际上内部会转化成CFRunLoopTimerRef并添加到当前线程的RunLoop中去，因此，如果当前线程中没有启动RunLoop的时候，该方法会失效。

#### CFRunLoopObserverRef
1. CFRunLoopObserverRef是RunLoop的观察者。每个观察者都可以观察RunLoop在某个模式下事件的触发并处理。可观察的时间点有：
	* kCFRunLoopEntry：即将进入RunLoop。
	* kCFRunLoopBeforeTimers：即将处理Timer。
	* kCFRunLoopBeforeSources：即将处理Source。
	* kCFRunLoopBeforeWaiting：即将进入休眠。
	* kCFRunLoopAfterWaiting：刚从休眠中被唤醒。
	* kCFRunLoopExit：即将退出RunLoop。

#### modeItem
1. 上面的Source/Timer/Observer被统称为mode item，一个item可以被同时加入多个mode。但一个item被重复加入同一个mode时是不会有效果的。如果一个mode中一个item都没有，则RunLoop会直接退出，不进入循环。

#### 系统利用RunLoop处理事件
1. 自动释放池的创建与释放
	1. 程序启动后，系统在主线程自动生成了两个观察者。
		* 一个观察者监测RunLoop的kCFRunLoopEntry状态，最高优先级order=-2147483647。设置这个观察者的目的在于在RunLoop启动刚进入的时候生成自动释放池(它会回调objc_autoreleasePoolPush()方法向当前的AutoreleasePoolPage增加一个POOL_BOUNDARY标志创建自动释放池)。由于优先级最高，因此先于所有其他回调操作生成。
		* 另一个观察者监测RunLoop的kCFRunLoopBeforeWaiting状态和kCFRunLoopExit状态，此时是最低优先级order=2147483647。该观察者的任务是当RunLoop在即将休眠时调用objc_autoreleasePoolPop()销毁自动释放池，根据池中的记录向池中所有对象发送release方法真正地减少其引用计数，并调用objc_autoreleasePoolPush()创建新的自动释放池。系统会根据情况从最新加入的对象一直往前清理直到遇到POOL_BOUNDARY标志。而当RunLoop即将退出时会调用objc_autoreleasePoolPop()释放自动释放池内对象。故autorelease的释放时机取决于RunLoop的运行状态。
	2. 主线程中执行的代码，通常都是写在RunLoop事件回调，Timer回调中，处于自动释放池范围内，因此不会出现内存泄漏，开发人员也不需要显式在主线程创建自动释放池了。 
	3. oc的自动释放池本质上就是延迟释放，将向自动释放池中对象发送的释放消息存在pool中，当pool即将销毁的时候向其中所有对象发送release消息使其计数减小。而自动释放池的创建和销毁也是由RunLoop控制的。
2. 识别硬件和手势
	1. 当一个硬件事件(触摸、锁屏、摇晃、加速等)发生后，先由IOKit.framework生成一个IOHIDEvent事件并由SpringBoard接收，然后由mach port转发到需要处理的app进程中。
	2. 当有硬件事件发生时，底层就会包装成一个IOHIDEvent事件，通过mach port转发到该Source1源中，触发__IOHIDEventSystemClientQueueCallback回调，并调用_UIApplicationHandleEventQueue()进行内部分发。这个方法会把IOHIDEvent进行预处理并包装成UIEvent进行处理和分发，包括UIGesture/处理屏幕选装/发送给UIWindow。
	3. 当用户点击屏幕时最先是产生了一个硬件事件，底层封装后触发RunLoop的Source1源，回调__IOHIDEventSystemClientQueueCallback函数处理，然后再触发RunLoop中的一个Source0的源，回调_UIApplicationHandleEventQueue函数将事件包装成UIEvent处理并分发。
3. 手势识别
	1. 当发生点击并包装好事件后RunLoop会进行事件分发，然后会触发_UIGestureRecognizerUpdate，并调用其中的回调函数，最后发送给对应GestureRecognizer的target。
	2. 系统默认注册了一个Source0源用以分发事件，回调_UIApplicationHandleEventQueue方法，然后系统会将对应的UIGestureRecognizer标记为待处理，然后还注册了一个观察者，监听RunLoop即将进入休眠的事件，回调_UIGestureRecognizerUpdateObserver()，该函数内部会获取到所有被标记为待处理的UIGestureRecognizer，执行相应的回调。
4. 界面刷新
	1. 当在操作UI时，比如改变了Frame、更新了UIView/CALayer的层次时，或者手动调用了UIView/CALayer的setNeedsLayout/setNeedsDisplay方法后，这个UIView/CALayer就被标记为待处理，并被提交到一个全局的容器去。
	2. 系统注册了一个观察者，这个观察者监听RunLoop即将进入休眠和即将退出的事件，回调_ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()方法，该方法中会遍历所有待处理的UIView或CALayer以执行绘制和调整，更新UI界面。

#### 日常用法
1. 线程池
	1. 线程池的使用是为了避免程序使用线程的时候频繁的创建和销毁线程从而造成不必要的过度消耗，因此通过线程池机制维持几个常驻线程，避免使用的时候频繁创建和销毁，达到节省资源和加快响应速度的目的。
	2. 除了主线程外的线程默认是创建执行完毕销毁的，这个时候若还需要维护住该线程，则需要手动创建该线程对应的RunLoop。RunLoop启动后，可以向该RunLoop添加一个port或Timer用以触发线程接收自己生成的事件从而分发处理。在这种方式中，RunLoop执行的主要任务是维持线程不退出，然后应用就可以利用performSelector:onThread:等方式将自己的事件传递给RunLoop处理了(AFNetworking就是这样生成网络线程的)。
2. 通过监听RunLoop处理事件
	1. 通过添加Observer监听主线程RunLoop，可以仿造主线程RunLoop进行UI更新(AsyncDisplayKit开源框架)。
	2. AsyncDisplayKit框架就是仿造QuartzCore/UIKit框架的模式，实现了一套类似的界面更新的机制。平时的时候将UI对象的创建、设置属性的事件放在队列中，通过在主线程添加Observer监听主线程RunLoop的kCFRunLoopBeforeWaiting和kCFRunLoopExit事件，在收到回调时，遍历队列里所有的事件并执行。
3. 通过合理利用RunLoop机制，可以将很多不是必须在主线程中执行的操作放在子线程中实现，然后在合适的时机同步到主线程中，这样可以节省在主线程执行操作的事件，避免卡顿。

#### 其他
1. NSRunLoopCommonModes模式的runloop中若有耗时操作则可能会引起UI的卡顿，解决方法是使用runloop分拆耗时操作。



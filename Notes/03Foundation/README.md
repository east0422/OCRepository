# Foundation


#### Delegate：
1. 通常发送者和接收者是直接的一对一关系。代理的目的是改变或传递控制链。允许一个类在某些特定时刻通知到其他类，而不需要获取到那些类的指针。可以减少框架复杂度。消息的发送者(sender)告知接收者(receiver)某个事件将要发生，delegate同意然后发送着响应事件，delegate机制使得接收者可以改变发送者的行为。
2. 优点：
	* 有严格的语法，所有能响应的事件必须在协议中有清晰的定义。
	* 因为有严格的语法，所以编译器能帮你检查是否实现了所有应该实现的方法，不容易遗忘和出错。
	* 使用delegate时，逻辑清楚，控制流程可跟踪和识别。
	* 在一个controller中可以定义多个协议，每个协议有不同的delegate。
	* 没有第三方要求保持/监视通信过程，出了问题可以比较方便定位错误代码。
	* 能够接收调用协议方法的返回值，意味着delegate能够提供反馈信息给controller。
3. 缺点：
 	* 需要写的代码比较多。
 	
#### KVO、KVC、Notification、Delegate、Block区别
1. 当希望监视一个属性，处理属性层消息事件时使用KVO；其他的尽量使用delegate；除非代码需要处理的东西确实很简单，那么用通知很方便。
2. delegate与block一般是用于两个对象一对一之间的通信交互，delegate需要定义协议方法，代理对象实现协议方法，并且需要建立代理关系才可以实现通信。
3. block更加简洁，类似于C里面的函数指针，都可以作为参数进行传递，用于回调。block可以在方法中定义实现，这样可以访问方法中的局部变量。不需要定义繁琐的协议方法，但是若通信事件比较多的话，建议使用delegate。
4. block块中使用了局部对象，则会将此对象retain，引用了当前对象的属性或者方法则会将当前对象retain。为了解决block循环引用，通常将当前对象赋给一个局部变量，并且使用__block关键字修饰该局部变量(__block修饰的局部对象在block块中使用不会retain)，使用该变量访问当前对象的属性和方法。
5. delegate效率比notification高。delegate方法比notification更加直接，需要关注返回值，所以delegate方法往往包含should这个很传神的词。相反，notification最大的特色就是不关心结果，所以notification往往用did。
6. 两个模块之间联系不是很紧密就用notification传值(例如多线程间传值)。
7. delegate只是一种较为简单的回调，且主要用在一个模块中，例如底层功能完成了，需要把一些值传到上层去，就事先把上层的函数通过delegate传到底层，然后在底层call这个delegate，它们都在一个模块中，完成一个功能，例如说NavigationController从B界面到A，点返回按钮(调用popViewController)可以用delegate比较好。

#### Foundation对象与Core Foundation对象区别
1. Foundation对象是OC的，Core Foundation对象是C的。
2. ARC下桥接: __bridge(F <-> CF), __bridge_retained(F -> CF), __bridge_transfer(CF -> F)。
3. MRC: __bridge, 直接强转。

#### Cocoa touch
1. 音频和视频：Core Audio，OpenAL，Media Library，AV Foundation。
2. 数据管理：Core Data，SQLite。
3. 图形和动画：Core Animation，OpenGL ES，Quartz 2D。
4. 网络：Bonjour，WebKit，BSD Sockets。
5. 用户应用：Address Book，Core Location，Map Kit，Store Kit。

#### 其他
1. 动态是在程序运行过程才执行的操作。





# Foundation

#### 单例 
1. 单例模式节省内存资源，一个应用就一个对象。在整个应用程序的生命周期内，单例对象的类必须保证只有一个实例对象存在。单例可以存储一些公共的数据，每个对象都能共享，访问，修改。单例在头文件中定义一个类方法，在实现文件中定义一个静态对象用于存储单例对象然后实现类方法获取单例对象，若希望多个alloc获取的也都是该单例对象则重写allocWithZone在其中处理静态对象。
2. 优点：
	* 对象只被初始化了一次，确保所有对象访问的都是唯一实例。
	* 只有一个实例存在，所以节省了系统资源，对于一些需要频繁创建和销毁的对象单例模式无疑可以提高系统的性能。
	* 允许可变数目的实例，基于单例模式我们可以进行扩展，使用与单例控制相似的方法来获得指定个数的对象实例，既节省系统资源又解决了单例对象共享过多有损性能的问题。
3. 缺点：
   * 职责过重，在一定程度上违背了"单一职责原则"。
   * 由于单例模式中没有抽象层，因此单例类的扩展有很大的困难。
   * 单例对象一旦创建，指针是保存在静态区的，单例对象的实例会在应用程序终止后才会被释放。
   * 滥用单例将会带来一些负面问题，如为了节省资源将数据库连接池对象设计为单例类，可能会导致共享连接池对象的程序过多而出现连接池溢出；如果实例化的对象长时间不被利用，系统会认为是垃圾而被回收，这将导致对象状态的丢失。
4. 简单实现：因为实例是全局的，因此要定义为全局变量，且需要存储在静态区不释放。不能存储在栈区。
	
	```
	@interface SingleObject : NSObject
	@property (nonatomic, copy)NSString *name;
	+(instancetype)shareInstance;
	@end
	
	#import "SingleObject.h"
	static SingleObject *_singleInstance = nil;
	@implementation SingleObject
	+(instancetype)shareInstance
	{
	    static dispatch_once_t onceToken;
	    dispatch_once(&onceToken, ^{
	        if (_singleInstance == nil) {
	            _singleInstance = [[self alloc]init];
	            _singleInstance.name = @"name";
	        }
	    });
	    return _singleInstance;
	}
	// alloc调用OC内部实际通过调用+(instancetype)allocWithZone
	+(instancetype)allocWithZone:(struct _NSZone *)zone
	{
	    static dispatch_once_t onceToken;
	    dispatch_once(&onceToken, ^{
	        _singleInstance = [super allocWithZone:zone];
	    });
	    return _singleInstance;
	}
	// 老对象直接调用copy
	-(id)copyWithZone:(NSZone *)zone
	{
	    return _singleInstance;
	}
	// 老对象直接调用copy
	-(id)mutableCopyWithZone:(NSZone *)zone {
	    return _singleInstance;
	}
	@end
	```

#### KVO
1. (Key-Value-Observing)一对多，观察者模式，键值观察机制，它提供了观察某一属性变化的方法，极大简化了代码KVO是一个对象能观察另一个对象属性的值，另两种模式更适合一个controller和其他的对象进行通信，而KVO适合任何对象监听另一个对象的改变，这是一个对象与另一个对象保持同步的一种方法。KVO只能对属性作出反应，不会用来对方法或动作作出反应。
2. 优点：
	* 提供一个简单的方法来实现两个对象的同步。
	* 能对非我们创建的对象作出反应。
	* 能够观察属性的最新值和先前值。
	* 用keypaths来观察属性，因此也可以观察嵌套对象。
3. 缺点：
 	* 观察属性必须使用string来定义，因此编译器不会出现警告和检查。
 	* 对属性的重构将导致观察不可用。
 	* 复杂的if语句要求对象正在观察多个值，这是因为所有的观察都通过一个方法来指向。
 	
#### KVO内部实现原理
1. KVO是基于runtime机制实现的。
2. 当某个类的对象第一次被观察时，系统就会在运行期动态地创建该类(Person)的一个派生类/子类(NSKVONotifying_Person)，在这个派生类中重写基类中任何被观察属性的setter方法。派生类在被重写的setter方法实现真正的通知机制。
3. 属性变化想要被监听到，需要调用属性对应的set方法更改该属性值而不是直接使用类似下划线方式更改属性值(KVC)。
4. KVO(键值观察)是一种能使得对象获取到其他对象属性变化的通知机制，它能够观察一个对象的KVC key path值的变化。
5. 实现KVO键值观察模式，被观察的对象必须使用KVC键值编码来修改它的实例变量，这样才能被观察者观察到。因此，KVC是KVO的基础或者说KVO的实现是建立在KVC的基础之上的。
6. 为了正确接受属性的变更通知，观察对象必须首先发送一个addObserver:forKeyPath:options:context:消息至被观察对象，用以传送观察对象和需要观察的属性的关键路径，以便于其注册。
7. 当监听的属性发生变动时，观察者收到observeValueForKeyPath:ofObject:change:context:消息,观察者必须实现这一方法。触发观察通知的对象和键路径、包含变更细节的字典，以及观察者注册时提交的上下文指针均被提交给观察者。
8. 当不再需要观察时可以发送一条指定观察方对象和键路径的removeObserver:forKeyPath:消息至被观察的对象，来移除一个键值观察者。
9. 使用了isa混写，当一个对象(假设是person对象，person的类是MYPerson)的属性值(假设person的age发生改变时，系统会自动生成一个继承自MYPerson的类NSKVONotifying_MYPerson，在这个类的setAge方法里面，调用[super setAge:age];[self willChangeValueForKey:@"age"];和[self didChangeValueForKey:@"age"];)，而这两个方法内部会主动调用监听者内部的-(void)observeValueForKeyPath这个方法。

#### KVC
1. Key-Value-Coding(键值编码)是一种间接访问对象实例变量的机制，该机制可以不需要调用存取方法和变量实例就可以访问对象的实例属性。允许开发者通过Key名直接访问对象的属性，或者给对象的属性赋值，而不需要调用明确的存取方法。这样就可以在运行时动态地访问和修改对象的属性。而不是在编译时确定。
2. KVC中的基本调用包括valueForKey:和setValue:forKey:两个方法，它们以字符串的形式向对象发送消息，字符串(key)是关注属性的关键，方法中指定key若没用下划线会自动添加下划线。当属性有set,get方法时若forkey的key跟我们set方法的方法名一样(都没有下划线或都有下划线)，那么会优先调用set方法（get方法一样）。
3. KVC还支持指定路径，用点号隔开valueForKeyPath:及setValue:forKeyPath:，若向数组请求一个键值，它实际上会查询数组中的每个对象来查找这个键值，然后将查询结果打包到另一个数组中并返回给你。
4. KVC简单运算，可以应用一些字符做简单运算(sum、min、max、avg、count)。
5. KVC破坏封装性，不推荐使用。
6. 一个对象在调用setValue时，检查是否存在相应key的set方法，存在就调用set方法；set方法不存在就查找_key的成员变量是否存在，存在就直接赋值；若_key没找到，就查找相同名称的key，存在就赋值；若还是没有就调用valueForUndefinedkey和setValue:forUndefinedKey。

#### Notification通知
1. NSNotification是iOS中一个调度通知的类，采用单例模式设计，在程序中实现传值、回调等。观察者模式，通常发送者和接收者是间接的多对多关系。消息的发送者告知接收者事件已经发生或将要发生，仅此而已，接收者并不能反过来影响发送者的行为。
2. NSNotificationCenter是一个通知中心，采用单例设计，每个应用程序都会有一个默认的通知中心，用于调度通知的发送和接收。允许当事件发生的时候通知一些对象，满足控制器与一个任意对象进行通信的目的，这种模式的基本特征就是接收到在该controller中发生某种而产生的消息，controller用一个key(通知名称)，这样对于controller是匿名的，其他的使用同样的key来注册了该通知的对象能对通知的事件作出响应。Notification主要用于一对多情况下通信，而且对象间不需要建立关系，但是使用通知代码可读性差。
3. 如果发送的通知指定了object对象，那么观察者接收的通知设置的object对象与其一样时才会接收到通知。但是接收通知若将这个参数设置为了nil，则会接收所有的通知。
4. 观察者的SEL函数指针可以有一个参数，参数就是发送对象本身，可以通过这个参数取到消息对象的userInfo,实现传值。
5. 优点：
	* 不需要写多少代码，实现简单。
	* 一个对象发出的通知，多个对象能进行响应，一对多的方式实现很简单。
6. 缺点：
	* 在编译期间不会检查通知是否能够被观察者正确的处理。
	* 在释放通知的观察者时，需要在通知中心移除观察者；
	* 需要第三方来管理controller和观察者的联系。
	* controller和观察者需要提前知道通知名称、UserInfo dictionary keys。如果这些没有在工作区间定义或通知名称不一致，那么会出现不同步的情况。
	* 通知发出后，发出通知对象不能从观察者获得任何反馈。
	* 在调试的时候通知传递控制流程很难控制和跟踪。

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
 	
#### Block：
1. iOS中一种比较特殊的数据类型，用来保存某一段代码，可以在恰当的时间再取出来调用。
2. 默认情况下，Block内部不能修改外面的局部变量。
3. Block内部可以修改使用__block修饰的局部变量，__block修饰的局部变量的地址和Block内部使用的同名变量地址不相同。
4. 作为参数格式 返回值类型 (^)(形参列表)。
5. 定义格式 返回值类型 (^block变量名称)(形参列表); 
6. 实现格式 ^ 返回值类型 (形参列表){功能语句……}。
7. 无参无返回值 void (^block1)() = ^{NSLog(@“aaaaa”);}。
8. 有参无返回值   void (^block2)(NSString *name) = ^(NSString *name){NSLog(@“%@”,name)}。
9. 有参有返回值   void (^sum)(int num1, int num2) = ^(int num1, int num2){return num1 + num2;}。
10. 当在block内部使用对象时block内部会对这个对象增加一个强引用。
	
#### KVO、KVC、Notification、Delegate、Block区别
1. 当希望监视一个属性，处理属性层消息事件时使用KVO；其他的尽量使用delegate；除非代码需要处理的东西确实很简单，那么用通知很方便。
2. delegate与block一般是用于两个对象一对一之间的通信交互，delegate需要定义协议方法，代理对象实现协议方法，并且需要建立代理关系才可以实现通信。
3. block更加简洁，类似于C里面的函数指针，都可以作为参数进行传递，用于回调。block可以在方法中定义实现，这样可以访问方法中的局部变量。不需要定义繁琐的协议方法，但是若通信事件比较多的话，建议使用delegate。
4. block块中使用了局部对象，则会将此对象retain，引用了当前对象的属性或者方法则会将当前对象retain。为了解决block循环引用，通常将当前对象赋给一个局部变量，并且使用__block关键字修饰该局部变量(__block修饰的局部对象在block块中使用不会retain)，使用该变量访问当前对象的属性和方法。
5. delegate效率比notification高。delegate方法比notification更加直接，需要关注返回值，所以delegate方法往往包含should这个很传神的词。相反，notification最大的特色就是不关心结果，所以notification往往用did。
6. 两个模块之间联系不是很紧密就用notification传值(例如多线程间传值)。
7. delegate只是一种较为简单的回调，且主要用在一个模块中，例如底层功能完成了，需要把一些值传到上层去，就事先把上层的函数通过delegate传到底层，然后在底层call这个delegate，它们都在一个模块中，完成一个功能，例如说NavigationController从B界面到A，点返回按钮(调用popViewController)可以用delegate比较好。

#### 可否将比较耗时的操作放在NSNotificationCenter中
1. 通知中心所做的操作在主线程，比较耗时的一般开启一个单独线程去跑。
2. 若在异步线程发的通知，则可执行比较耗时的操作。
3. 若在主线程发的通知，则不可以执行比较耗时的操作。

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





# KVO


#### 简述
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




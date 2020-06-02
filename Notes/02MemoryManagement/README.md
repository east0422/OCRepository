# 内存管理


#### 内存泄露检查
1. 使用Analyze进行代码的静态分析。
2. 使用Leak进行动态分析。
3. 为避免不必要的麻烦，开发时尽量使用ARC。
4. 打开僵尸对象检测，进行野指针的检测。 
5. dealloc打印log看是否调用。
6. 第三方检测工具(MLeaksFinder使用pod直接安装，原项目不需要任何修改)。

#### OC内存管理
1. MRC(Manual Reference Counting)手动内存管理，需要程序员手动创建对象申请内存然后再手动释放。
	* 管理内存原则是谁创建谁释放，也就是说在使用过程中谁retain(或alloc)谁release。
	* 在使用MRC时，当引用计数为0时必须回收，引用计数不为0时则不回收；如果内存计数为0了没回收会造成内存泄漏。
	* 若想使用已经创建好的某个对象，不能直接拿过去用，需要先retain让计数加1，用完之后应该release计数减1，否则会造成野指针。
2. ARC(Automatic Reference Counting)自动引用计数。代码中自动加入retain/release，原先需要手动添加用来处理内存管理引用计数的代码可以自动地由==编译器==完成。
   * 使用ARC只要某个对象被任一strong指针指向，那么它将不会被销毁。如果对象没有被任何strong指针指向，那么就将被销毁。
   * 使用ARC后不允许调用release、retain、retainCount等方法。
   * 允许重写dealloc，但不允许调用[super dealloc]，系统会默认调用[super dealloc]。
   * 不可以使用区域 NSZone。
   * 若A有个属性参照B，B中也有个属性参照A，而且都是strong参照的话那么两个对象都无法释放，从而会出现内存泄漏，常见解决方法是将一个参照改为weak避免循环参照。
   * 若有个ViewController中有无限循环，也会导致即使ViewController对应的view消失了，ViewController也不能释放，从而会出现内存泄漏。
3. Autorelease Pool内存池，类似于release，但不等同于它，release调用后引用计数马上减1。autorelease是在创建对象的时候写的，表示加入自动释放池，当释放池销毁时，才调用引用计数减1。自动释放池需要手动创建。当调用[pool drain]方法时会调用池中全部对象release掉他们。内存池是可以嵌套的。

#### 什么时候会发生内存泄漏和内存溢出
1. 当程序在申请内存后，无法释放已申请的内存空间(例如一个对象或变量使用完成后么有释放，这个对象一直占用着内存)就会发生内存泄漏。若内存泄漏一直不停的堆积，则无论多少内存迟早都会被占光，内存泄漏会最终导致内存溢出。
2. 当程序在申请内存时，没有足够的内存空间供其使用，出现out of memory(例如申请了一个int, 当给它存了long才能存下的数)，就是内存溢出。
3. 不再需要的对象没有释放就会导致内存泄漏，内存泄漏会导致应用闪退。
4. 正在使用的对象被释放了，导致野指针，访问野指针会导致程序崩溃。

#### 自动释放池底层实现
1. 自动释放池以栈的形式实现：当你创建一个新的自动释放池时，它将被添加到栈顶。当一个对象收到发送autorelease消息时，它被添加到当前线程的处于栈顶的自动释放池中，当自动释放池被回收时，它们从栈中被删除，并且会给池子里面所有的对象都做一次release操作。
2. 一般来说，除了alloc、new或copy之外的方法创建的对象都被声明了autorelease。
3. 不要对一个对象多次调用autorelease(你调用几次autorelease当自动释放池被销毁的时候就会调用几次release)，也不要调用autorelease后再调用release，避免野指针。
4. 当执行到自动释放池后面的大括号的时候，自动释放池会出栈，此时该栈中所有的对象都会做一次release操作。
5. 当一个对象很小，使用次数也比较少时可以使用自动释放池，快捷构造方法及其他需要延长对象生命周期的地方也可以使用自动释放池。
6. 延迟对象的释放，当一个对象占用内存比较大时不要使用自动释放池。

#### 内存管理基本原则
1. 如果使用alloc、copy(mutableCopy)或者retain一个对象时，你就有义务，向它发送一条release或者autorelease消息。其他方法创建的对象，不需要由你来管理释放。

#### autorelease释放
1. 手动干预释放就是指定autoreleasepool，当前作用域大括号结束就立即释放。
2. 系统自动去释放：不手动指定autoreleasepool，autorelease对象会在当前的runloop迭代结束时释放。
3. kCFRunLoopEntry(1)：第一次进入会自动创建一个autorelease。
4. kCFRunLoopBeforeWaiting(32)：进入休眠状态前会自动销毁一个autorelease，然后重新创建一个新的autorelease。
5. kCFRunLoopExit(128)：退出runloop时会自动销毁最后一个创建的autorelease。

#### 内存中堆区和栈区的区别
1. 栈区(stack)由编译器自动分配释放，存放方法(函数)的参数值，局部变量的值等。
2. 栈区内存由系统管理，局部变量保存在栈中，当变量离开了其所在的代码块就会被回收。
3. 堆区(heap)一般由程序员分配与释放，若程序员不释放，则内存溢出，OC中的对象保存在堆中。

#### @property关键字
1. retain默认生成set方法对旧对象release, 对新对象retain。
2. copy默认生成set方法对旧对象release,对新对象copy，用于NSString及block。
3. assign直接赋值，不管理内存，适用于非OC对象类型及循环引用中一端。
4. nonatomic非原子属性，非线程安全的，不会给setter方法加锁，访问速度快，高性能，通常会加上该值。
5. atomic原子属性，线程安全，会给setter方法加锁，访问速度比较慢，低性能，默认是该值。
6. 让编译器自动生成与类成员变量相同名getter、setter方法，创建的成员变量是以下划线_开头，它创建的默认修饰域是private，还能对对象内存进行管理。

#### 自动释放池
1. 系统中存在一个自动释放池栈，用来存储多个对象类型的指针变量，简单的看当遇到@autoreleasepool{时会将这个自动释放池放入栈中，当遇到与之对应的}时，自动释放池出栈，自动释放池出栈时会对池中所有对象进行一次release操作。
2. 自动释放池栈中，只有栈顶自动释放池是活动的，其它的都在休眠。
3. 当调用对象的autorelease时会把这个对象放入栈顶的自动释放池中。
4. 只要是从方法中返回一个对象都要使用自动释放池。
5. autorelease对象是在当前runloop迭代结束时释放的，而它能够释放的原因是系统在每个runloop迭代中都加入了自动释放池Push和Pop。通过Observer监听runloop的状态，一旦监听到runloop即将进入睡眠等待状态(kCFRunLoopBeforeWaiting)，就会释放自动释放池。
6. 多次调用对象的autorelease方法会导致野指针异常。

#### AutoreleasePool
1. 每一个线程的autoreleasepool其实就是一个指针的堆栈。
2. 每一个指针代表一个需要release的对象或者POOL_SENTINEL(哨兵对象，代表一个autoreleasepool的边界)。
3. 一个pool token就是这个pool所对应的POOL_BOUNDARY(是一个边界对象nil，之前的源代码变量名是POOL_SENTINEL哨兵对象，用来区别每个page即每个AutoreleasePoolPage边界)的内存地址。当这个pool被pop的时候，所有内存地址在pool token之后的对象都会被release。
4. 这个堆栈被划分成了一个以page为结点的双向链表。pages会在必要的时候动态地增加或删除。
5. thread-local storage(线程局部存储)指向hot page，即最新添加的autoreleased对象所在的那个page。
6. ARC产物，为了替代人工管理内存。实质上是使用编译器替代人工在适当的位置插入release、autorelease等内存释放操作。

#### AutoreleasePoolPage
1. 每个AutoreleasePoolPage对象占用4096个字节(虚拟内存一页的大小)的内存，除了用来存放它内部的成员变量外，剩下的空间用来存放autorelease对象的地址。
2. 所有的AutoreleasePoolPage对象都是通过双向链表的形式连接在一起。
3. 内部结构(从高地址到低地址)：
	1. magic(magic_t const)：用来校验AutoreleasePoolPage的结构是否完整。
	2. next(id *)：指向最新添加的autoreleased对象的下一个位置(即指向下一个能存放autorelease对象地址的位置)，初始化时指向begin()。
	3. thread(pthread_t const)：指向当前线程。
	4. parent(AutoreleasePoolPage * const)：指向父结点(前一个page)，第一个结点的parent值为nil。
	5. child(AutoreleasePoolPage *)：指向子结点(指向下一个page)，最后一个结点的child值为nil。
	6. depth(uint32_t const)：代表深度，从0开始，往后递增1。
	7. hiwat(uint32_t)：代表high water mark。
	8. 当next==begin()时，表示AutoreleasePoolPage为空，当next==end()时，表示AutoreleasePoolPage已满。
4. AutoreleasePoolPage::push()
	1. 每调用一次push操作就会创建一个新的autoreleasepool，即将一个POOL_BOUNDARY入栈(往AutoreleasePoolPage中的next位置插入一个POOL_BOUNDARY)，并且返回插入的POOL_BOUNDARY的内存地址，这个地址就是上面提到的pool token，在执行pop操作时作为函数的入参。
	2. push就是压栈的操作，先加入边界对象，然后添加person1对象，然后person2对象...以此类推。
	3. push函数通过调用autoreleaseFast函数来执行具体的插入操作。

		```
		static inline id *autoreleaseFase(id obj) {
			AutoreleasePoolPage *page = hotPage();
			if (page && !page->full()) { // 当前page存在且没有满时，直接将对象添加到当前page中，即next指向的位置
				return page->add(obj);
			} else if (page) { // 当前page存在且已满时，创建一个新的page，并将对象添加到新创建的page中
				return autoreleaseFullPage(obj, page);
			} else { // 当前page不存在时，即还没有page时创建第一个page并将对象添加到新创建的page中
				return autoreleaseNoPage(obj);
			}
		}
		```
5. AutoreleasePoolPage::pop(ctx)
	1. 调用pop操作时传入一个POOL_BOUNDARY的内存地址(push方法返回值即pool token)，会从最后一个入栈的对象开始发送release消息，直到遇到这个POOL_BOUNDARY(因为是双向链表，可以向上寻找)。
6. AutoreleasePoolPage::autorelease(obj)
	1. 它跟push操作实现非常相似，只不过push操作插入的是一个POOL_BOUNDARY，而autorelease操作插入的是一个具体的autorelease对象。


#### 其他
1. 系统自带的绝大多数类方法返回的对象都是经过autorelease的。
2. [NSArray arrayWithObject: <id>]方法添加对象后不需要对这个数组做释放操作，因为这个对象被放到自动释放池中。





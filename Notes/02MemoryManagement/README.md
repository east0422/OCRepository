# 内存管理

#### 内存泄露检查
1. 使用Analyze进行代码的静态分析。
2. 使用Leak进行动态分析。
3. 为避免不必要的麻烦，开发时尽量使用ARC。

#### 非自动内存管理MRC下单例模式实现
1. 创建一个单例对象的静态实例，并初始化为nil。
2. 创建一个类的类工厂方法，当且仅当这个类的实例为nil时生成一个该类的实例。
3. 实现NSCopying协议，覆盖allocWithZone:方法，确保用户在直接分配和初始化对象时不会产生另一个对象。
4. 覆盖release、autorelease、retain、retainCount方法，以此确保单例的状态。
5. 在多线程的环境中，注意使用@synchronized关键字或GCD确保静态实例被正确的创建和初始化。

#### block在ARC和MRC中使用区别及注意点
1. 若dealloc能调用super或能够使用retain，release则为MRC。
2. 若没有引用外部局部变量，block都放在全局区，在ARC和MRC中类型都是_NSGlobalBlock_，这种类型的block可以理解成一种全局的block，不需要考虑作用域问题。
3. MRC下若引用外部局部变量，block放在栈里面NSStackBlock，block只能使用copy不能使用retain，用retain，block还是在栈里面。用copy的原因，是把block从栈区拷贝到堆区，因为栈区中的变量出了作用域之后就会被销毁，无法在全局使用，所以应该把栈区的属性拷贝到堆区中全局共享,这样就不会被销毁了。
4. ARC下若引用外部局部变量，block放在堆里面NSMallocBlock，block使用strong，尽量不要使用copy，因为ARC下的属性本来就在堆区。
5. 在block内部访问外部变量时，block内部会对外部的变量进行一次拷贝，在blcok内部操作的是拷贝后的副本，不会影响外部变量，这个变量在堆区。block内部不允许修改外部变量，若非要修改外部变量则需要使用__block修饰外部变量。
6. __block修饰的变量在ARC中引用计数会加一，在MRC中引用计数不变。
7. 只要block中用到了对象的属性或者函数，block就会持有该对象而不是该对象中的某个属性或函数。
8. 并不是所有block都要用__weak来修饰对象，若self没有对block持有不会形成循环引用就不必使用__weak。
9. 一个常见错误使用是担心循环引用错误使用__weak，如`__weak typeof(self) weakSelf = self; dispatch_async(dispatch_get_main_queue(), ^{ [weakSelf doSomething]; });` 。因为将block作为参数传给dispatch_async时，系统会将block拷贝到堆上，而且block会持有block中用到的对象，因为dispatch_async并不知道block中对象会在什么时候被释放，为了确保系统调度执行block中的任务时其对象没有被意外释放掉，dispatch_async必须自己retain一次对象(即self)，任务完成后再release对象。但这里使用__weak使dispatch_async没有增加self的引用计数，这使得在系统在调度执行block之前，self可能已被销毁，但系统并不知道这个情况，导致block执行时访问已经被释放的self，而达不到预期结果。
10. 应注意避免循环引用。

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

#### ARC
1. ARC是Automatic Reference Counting的简称，称之为自动引用计数，是iOS5.0之后推出的内存管理的新特性。
2. 是编译器特性，是Xcode帮我们处理的，当编译器发现alloc、retain等时自动帮我们插入release代码。
3. 本质上还是使用引用计数来管理对象，只是我们在编写代码时，不需要向对象发送release或autorelease方法，也不可以调用delloc方法，编译器会在合适的位置自动给用户生成release消息(autorelease)。
4. GC全程是garbage collection, 内存垃圾回收机制，ARC比GC性能好。iOS开发只支持手动内存管理与ARC, Mac开发支持GC垃圾回收机制，10.8之后弃用了GC, 推荐使用ARC。
5. ARC若内存管理不当的话，同样会存在内存泄漏，例如：ARC中循环引用导致内存不能释放而泄漏，OC对象与CoreFoundation类之间桥接时管理不当也会产生内存泄漏。
6. 不能调用release、retain、autorelease、retainCount。可以重写dealloc但不能调用[super dealloc]。
7. 循环引用中必须有一端使用weak。
8. 如果需要对特定文件开启或关闭ARC，可以在工程选项中选择Targets -> Compile Phases -> Compile Source，在里面找到对应文件，添加flag:
	* 打开ARC: -fobjc-arc。
	* 关闭ARC: -fno-objc-arc。

#### MRC
1. 当需要一个对象时就给这个对象的引用计数器加1，当不再需要这个对象时就将该对象引用计数器减1。
2. setter方法设置新对象时需要对新对象做一次retain操作，当原来的对象不需要了，需要对原来的对象做一次release操作。
3. dealloc方法当一个对象即将被销毁时会调用这个方法，它就相当于对象的遗言，在这里释放其它成员所占用的内存，在释放内存前要先调用[super dealloc]。
4. 循环引用中必须有一端是assign的。

#### 内存中堆区和栈区的区别
1. 栈区(stack)由编译器自动分配释放，存放方法(函数)的参数值，局部变量的值等。
2. 栈区内存由系统管理，局部变量保存在栈中，当变量离开了其所在的代码块就会被回收。
3. 堆区(heap)一般由程序员分配与释放，若程序员不释放，则内存溢出，OC中的对象保存在堆中。

#### 引用计数器
1. 引用计数器占四个字节，每个对象都有自己的引用计数器，是一个整数，表示对象的引用次数，即有多少人在使用这个OC对象。
2. 当创建一个新的对象时，它的引用计数器默认为1；当一个对象的引用计数为0时，对象占用的内存就会被回收。
3. 给对象发送一条retain消息，计数器加1；给对象发送一条release消息，计数器减1；
4. 每当一个对象的引用计数为0时，那么他将被销毁(可能不是立即销毁，什么时候销毁由系统决定)，其占用的内存将被系统回收；当一个对象被销毁时，系统会自动向对象发送一条dealloc消息。若重写dealloc方法则必须在最后调用[super dealloc]。也不要直接调用dealloc方法。

#### @property关键字
1. retain默认生成set方法对旧对象release, 对新对象retain。
2. copy默认生成set方法对旧对象release,对新对象copy，用于NSString及block。
3. assign直接赋值，不管理内存，适用于非OC对象类型及循环引用中一端。
4. nonatomic非原子属性，非线程安全的，不会给setter方法加锁，访问速度快，高性能，通常会加上该值。
5. atomic原子属性，线程安全，会给setter方法加锁，访问速度比较慢，低性能，默认是该值。
6. 让编译器自动生成与类成员变量相同名getter、setter方法，创建的成员变量是以下划线_开头，它创建的默认修饰域是private，还能对对象内存进行管理。

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





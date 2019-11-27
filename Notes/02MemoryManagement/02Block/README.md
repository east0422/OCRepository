# Block


#### block在ARC和MRC中使用区别及注意点
1. 无论当前环境是ARC还是MRC，只要block没有访问外部变量block始终在全局区，类型都是_NSGlobalBlock_，这种类型的block可以理解成一种全局的block，不需要考虑作用域问题。
2. MRC下
	* block如果访问外部变量，block放在栈里面NSStackBlock。
	* 对block使用retain，block还是在栈里面，不能保存在堆里。
	* block只有使用copy，才能放到堆里。用copy的原因，是把block从栈区拷贝到堆区，因为栈区中的变量出了作用域之后就会被销毁，无法在全局使用，所以应该把栈区的属性拷贝到堆区中全局共享,这样就不会被销毁了。
	* dealloc中能调用[super dealloc]，能够使用retain，release。
	* __block修饰的变量在MRC中引用计数不变。
3. ARC下
	* block如果访问外部变量，block在堆里NSMallocBlock。
	* block使用strong，尽量不要使用copy，因为ARC下的属性本来就在堆区。
	* __block修饰的变量在ARC中引用计数会加一。
4. block循环引用
	* 若要在block中直接使用外部强指针会发生错误，常使用代码`__weak typeof(self) weakSelf = self;`在block外部实现可以解决。
	* 并不是所有block都要用__weak来修饰对象，若self没有对block持有不会形成循环引用就不必使用__weak。
	* 若在block内部使用延时操作还是用弱指针的话可能会取不到该弱指针，需要在block内部再将弱指针强引用一下`__strong typeof(self) strongSelf = weakSelf;`。
	* 一个常见错误使用是担心循环引用而错误使用__weak，如`__weak typeof(self) weakSelf = self; dispatch_async(dispatch_get_main_queue(), ^{ [weakSelf doSomething]; });` 。因为将block作为参数传给dispatch_async时，系统会将block拷贝到堆上，而且block会持有block中用到的对象，因为dispatch_async并不知道block中对象会在什么时候被释放，为了确保系统调度执行block中的任务时其对象没有被意外释放掉，dispatch_async必须自己retain一次对象(即self)，任务完成后再release对象。但这里使用__weak使dispatch_async没有增加self的引用计数，这使得在系统在调度执行block之前，self可能已被销毁，但系统并不知道这个情况，导致block执行时访问已经被释放的self，而达不到预期结果，故需要在内部再强引用一下。
5. 在block内部访问外部变量时，block内部会对外部的变量进行一次拷贝，在block内部操作的是拷贝后的副本，不会影响外部变量，这个变量在堆区。block内部不允许修改外部变量，若非要修改外部变量则需要使用__block修饰外部变量。
6. 只要block中用到了对象的属性或者函数，block就会持有该对象而不是该对象中的某个属性或函数。
7. block访问的外部变量是普通局部变量那么是值传递，外部变化不会影响里面。若访问的外部变量是__block或static或全局变量那么是指针传递，外部变化里面也跟着变化。


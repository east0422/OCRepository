# 运行时
	runtime属于OC的底层实现，可以进行一些非常底层的操作，使用runtime在运行时可以动态创建一个类(KVO底层实现原理)，还可以动态的为某个类添加修改属性和方法及遍历类的所有成员和成员方法。使用时常引入<objc/message.h>和<objc/runtime.h>，message.h包含runtime.h。

#### runtime实现机制
1. 运行时机制，是一套C语言库。
2. 实际上我们所编写的所有OC代码，最终都是转成了runtime库的东西(比如类转成了runtime库里面的结构体等数据类型，方法转成了runtime库里面的C语言函数，平时调用方法都是转成了objc_msgSend函数)。
3. runtime是OC的底层实现，是OC的幕后执行者。
4. runtime库里面包含了根类、成员变量、方法相关的api，可以获取类里面的所有成员变量，为类动态添加成员变量和新的方法，动态改变类的方法实现等。

#### Method
1. 结构体指针objc_method，成员方法。
2. 会获取到property对应属性自动生成的getter, setter方法及自定义方法，{}中成员变量是不会自动生成对应的getter, setter方法的。
3. 获取的成员方法不仅仅是.h头文件，.m实现文件及类别中成员方法都能获取到。
4. 不能获取到父类中的方法，若想获取到父类中的方法则需遍历对应父类直到NSObject为止。
5. 不能获取类方法，只能获取成员方法。

	```
	unsigned int numMethods;
	// copy在不使用时记得释放
	Method *methods = class_copyMethodList(aClass, &numMethods);
	for (int i = 0; i < numMethods; ++i) {
		SEL sel = method_getName(methods[i]);
		const char *methodName = sel_getName(sel);
		NSLog(@"%@ method: %s", aClass, methodName);
	}
	free(methods);
	```

#### Ivar
1. 结构体指针objc_ivar，成员变量。
2. 会获取到{}中声明的变量和@property声明的变量，@property声明的变量前若没加下划线会自动加下划线。
3. 获取的成员变量不仅仅是.h头文件，.m实现文件中也是能获取的。
4. 不能获取到父类中的成员变量，若想获取到父类中的成员变量则需遍历父类直到NSObject为止。

	```
	unsigned int numIvars;
	Ivar *vars = class_copyIvarList(aClass, &numIvars);
	for (int i = 0; i < numIvars; ++i) {
	   Ivar ivar = vars[i];
	   const char *ivarName = ivar_getName(ivar);
	   const char *ivarType = ivar_getTypeEncoding(ivar);
	   NSLog(@"%@ ivar: %s, type: %s", aClass, ivarName, ivarType);
	}
	free(vars);
	```

#### 获取Person Class
1. [Person class]。
2. objc_getRequiredClass("Person")。
3. NSClassFromString(@"Person")。
 
#### objc_object、objc_class、objc_method等结构体
1. 定义在objc/objc.h及objc/runtime.h头文件中。
2. 结构体代码定义

	```
	struct objc_object {
		Class isa OBJC_ISA_AVAILABILITY;
	};
	struct objc_class {
		Class isa OBJC_ISA_AVAILABILITY; // 元类
	#if !__OBJC2__
		Class super_class; // 超类
		const char *name; // 实例名
		long version;	// 版本
		long info;	// 其它信息
		long instance_size;	// 实例大小
		struct objc_ivar_list *ivars; // 实例变量列表
		struct objc_method_list **methodLists; // 实例方法列表
		struct objc_cache *cache; // 缓存区
		struct objc_protocol_list *protocols; // 实例实现协议
	#endif
	};
	struct objc_method_list {
		struct objc_method_list *obsolete;
		int method_count;
	#ifdef __LP64__
		int space;
	#endif
		struct objc_method method_list[1];
	};
	struct objc_method {
		SEL method_name;
		char *method_types;
		IMP method_imp;
	};
	```
	
#### objc_property_t
1. 结构体指针objc_property，property属性。
2. 只会获取到property声明的属性，不会获取到{}中声明的成员变量，并且获取到的property属性名不会在前面自动添加下划线。
3. 获取的属性不仅仅是.h头文件，.m实现文件中也是能获取的。
4. 不能获取到父类中的属性，若想获取到父类中的属性则需遍历父类直到NSObject为止。

	```
	unsigned int numProperties;
	objc_property_t *properties = class_copyPropertyList(aClass, &numProperties);
	for (int i = 0; i < numProperties; ++i) {
	   objc_property_t property = properties[i];
	   const char *proName = property_getName(property);
	   NSLog(@"%@ property: %s", aClass, proName);
	}
	free(properties);
	```

#### objc_msgSend
1. Xcode5开始苹果不建议使用底层函数，若想使用则需先将build setting中objc_msgSend值YES改为NO。
2. 若直接不能使用发生崩溃，则尝试先定义原型再调用。
3. objc_msgSend(obj, foo)实际做如下事情
	1. 首先通过obj的isa指针找到它的class。
	2. 在class的method list中找foo。
	3. 如果class中没找到foo，继续往它的superclass中找。
	4. 一旦找到foo这个函数，就去执行它的实现IMP。
	5. 在找到foo之后会把foo的method_name作为key，method_imp作为value放到cache中存起来，当再次收到foo消息是可以直接在cache中找到，避免去遍历objc_method_list。
4. 如果objc_msgSend(obj, foo)中foo没有找到的话，通常情况程序会在运行时挂掉并抛出unrecognized selector sent to...异常，但在异常抛出钱，OC的运行时会给三次拯救程序的机会：
	1. Method resolution：OC运行时会调用+resolveInstanceMethod:或+resolveClassMethod:让有机会提供一个函数实现，若添加了函数并返回YES，那么运行时系统会重新启动一次消息发送的过程。
		
		```
		void fooMethod(id obj, SEL _cmd) {
			// dosomething
		}
		// 也可以直接使用runtime方法直接快速创建一个imp
		// IMP fooIMP = imp_implementationWithBlock(^(id _self) {
		//	// dosomething
		// });
		+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
			if (aSEL == @selector(foo:)) {
				class_addMethod([self class], aSEL, (IMP)fooMethod, "v@:");
				return YES;
			}
			return [super resolveInstanceMethod:aSEL];
		}
		```
	2. Fast forwarding：若resolve方法返回NO，运行时就会移到下一步即"消息转发(Message Forwarding)"。如果目标对象实现了-forwardingTargetForSelector:，runtime这时就会调用这个方法，给你把这个消息转发给其他对象的机会。只要这个方法返回的不是nil和self，整个消息发送的过程就会被重启，当然发送的对象会变成返回的那个对象。否则就会继续Normal forwarding。这里叫Fast是为了区别下一步的转发机制，因为这一步不会创建任何新的对象，所以相对更快点。
		
		```
		- (id)forwardingTargetForSelector:(SEL)aSEL {
			if (aSelector == @selector(foo:)) {
				return otherObj;
			}
			return [super forwardingTargetForSelector:aSEL];
		}
		```
	3. Normal forwarding：这一步是runtime最后一次挽救的机会，首先它会发送-methodSignatureForSelector:消息获得函数的参数和返回值类型，若返回nil则会发出-doesNotRecognizeSelector:消息，程序这时也就挂掉了。若赶回了一个函数签名，runtime就会创建一个NSInvocation对象并发送-forwardInvocation:消息给目标对象。NSInvocation实际上就是对一个消息的描述，包括selector以及参数等信息。所以你可以在-forwardInvocation:里修改传进来的NSInvocation对象，然后发送-invokeWithTarget:消息给它，穿进去一个新的目标。

		```
		- (void)forwardInvocation:(NSInvocation *)invocation {
			SEL sel = invocation.selector;
			if ([otherObj respondsToSelector: sel]) {
				[invocation invokeWithTarget:otherObj];
			} else {
				[self doesNotRecognizeSelector: sel];
			}
		}
		```

#### method_exchangeImplementations
1. 可交换两个方法的实现，通常在load中使用，当一个类被读到内存的时候runtime会给这个类及它的每一个类别读发送一个+load:消息。
2. 注意调用方法，避免方法交换后调用的实际上是自身方法而造成死循环。

	```
	Method urlWithStr = class_getClassMethod([NSURL class], @selector(URLWithString:));
	// eastURLWithString:方法中记得调用eastURLWithString:方法，若此处调用URLWithString:原始方法则会循环调用此方法造成死循环，两个方法在此处已经交换了。
	Method eastUrlWithStr = class_getClassMethod([NSURL class], @selector(eastURLWithString:));
	// 交换两个方法
	method_exchangeImplementations(urlWithStr, eastUrlWithStr);
	```

#### oc中的反射机制
1. class反射：通过类名的字符串形式实例化对象。

	```
	Class class = NSClassFromString(@"Teacher");
	Teacher *teacher = [[class alloc] init];
	// 将类名变为字符串
	Class class = [Teacher class];
	NSString *className = NSStringFromClass(class);
	
	```
2. SEL反射：通过方法的字符串形式实例化方法。

	```
	SEL selector = NSSelectorFromString(@"setName");
	[teacher performSelector: selector withObject: @"Wang"];
	// 将方法变为字符串
	NSStringFromSelector(selector);
	```

#### 能否向编译后得到的类添加实例变量，能否向运行时创建的类中添加实例变量？
1. 不能想编译后得到的类添加实例变量。因为编译后的类已经注册在runtime中，类结构体中的objc_ivar_list实例变量的链表和instance_size实例变量的内存大小已经确定，同时runtime会调用class_setIvarLayout或class_setWeakIvarLayout来处理strong weak引用。因此不能向存在的类中添加实例变量。
2. 可以向运行时创建的类中添加实例变量。运行时创建的类是可以添加实例变量，调用class_addIvar函数，但是得在调用objc_allocateClassPair之后，objc_registerClassPair之前。原理同上。




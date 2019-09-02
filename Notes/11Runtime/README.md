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
	// id是一个参数类型，它是指向某个类的实例的指针
	typedef struct objc_object *id;
	// objc_object结构体包含一个isa指针，根据isa指针就可以找到对象所属的类。isa指针在代码运行时并不总指向实例对象所属的类型，所以依靠它来确定类型，要想确定类型还是需要用对象的-class方法(KVO的实现原理就是将被观察对象的isa指针指向一个中间类而不是真实类型)。
	struct objc_object {
		Class isa OBJC_ISA_AVAILABILITY;
	};
	
	// Class其实是指向objc_class结构体的指针。
	typedef struct objc_class *Class;
	// 一个运行时类中关联了它的父类指针、类名、成员变量、方法、缓存以及附属的协议
	struct objc_class {
		Class isa OBJC_ISA_AVAILABILITY; // 指向元类
	#if !__OBJC2__
		Class super_class // 超类
	OBJC2_UNAVAILABLE;
		const char *name // 类名
	OBJC2_UNAVAILABLE;
		long version	// 类的版本信息，默认为0
	OBJC2_UNAVAILABLE;
		long info	// 类信息，供运行期使用的一些位标识
	OBJC2_UNAVAILABLE;
		long instance_size	// 该类的实例变量大小
	OBJC2_UNAVAILABLE;
		struct objc_ivar_list *ivars // 该类的成员变量链表
	OBJC2_UNAVAILABLE;
		struct objc_method_list **methodLists // 方法定义的链表
	OBJC2_UNAVAILABLE;
		struct objc_cache *cache // 方法缓存。对象接到一个消息会根据isa指针查找消息对象，这时会在methodLists中遍历，如果cache了，常用的方法调用时就能够提高调用效率
	OBJC2_UNAVAILABLE;
		struct objc_protocol_list *protocols // 协议链表
	OBJC2_UNAVAILABLE;
	#endif
	} OBJC2_UNAVAILABLE;
	
	// 成员变量列表
	struct objc_ivar_list {
		int ivar_count
	OBJC2_UNAVAILABLE;
	#ifdef __LP64__
		int space
	OBJC2_UNAVAILABLE;
	#endif
		struct objc_ivar ivar_list[1] // 单个成员变量信息
	OBJC2_UNAVAILABLE;
	} OBJC2_UNAVAILABLE;
	
	// 成员变量
	typedef struct objc_ivar *Ivar;
	struct objc_ivar {
		char *ivar_name
	OBJC2_UNAVAILABLE;
		char *ivar_type
	OBJC2_UNAVAILABLE;
		int ivar_offset // 基地址偏移字节
	OBJC2_UNAVAILABLE;
	#ifdef __LP64__
		int space
	OBJC2_UNAVAILABLE;
	#endif
	}
	
	// 方法列表。可以动态修改*methodLists的值来添加成员方法，这也是Category实现的原理，同样解释了Category不能添加属性的原因
	struct objc_method_list {
		struct objc_method_list *obsolete
	OBJC2_UNAVAILABLE;
		int method_count
	OBJC2_UNAVAILABLE;
	#ifdef __LP64__
		int space
	OBJC2_UNAVAILABLE;
	#endif
		struct objc_method method_list[1] // 单个方法信息
	OBJC2_UNAVAILABLE;
	};
	
	// 方法结构体，存储类方法名、方法类型和方法实现
	typedef struct objc_method *Method;
	struct objc_method {
		SEL method_name // 方法名
	OBJC2_UNAVAILABLE;
		char *method_types // 方法的参数类型和返回值类型
	OBJC2_UNAVAILABLE;
		IMP method_imp		// 方法的实现，本质是一个函数指针
	OBJC2_UNAVAILABLE;
	};
	
	// IMP是一个函数指针，由编译器生成的。当你发起一个ObjC消息之后，最终它会执行哪段代码就是由这个函数指针指定的。而IMP这个函数指针就指向了这个方法的实现。一组id和SEL参数和一个确定唯一的方法实现地址是一一对应的。
	typedef id (*IMP)(id, SEL, ...);
	
	// Cache为方法调用的性能进行优化，每当实例对象接收到一个消息时，它不会直接在isa指针指向的类的方法列表中遍历查找能够响应的方法，而是优先在Cache中查找。Runtime系统会把被调用的方法存到Cache中，如果一个方法被调用，那么它有可能今后还会被调用，下次查找时效率会更高(就像计算机组成原理中CPU绕过主存先访问Cache一样)。
	typedef struct objc_cache *Cache;
	struct objc_cache {
		unsigned int mask /* total = mask + 1 */
	OBJC2_UNAVAILABLE;
		unsigned int occupied
	OBJC2_UNAVAILABLE;
		Method buckets[1]
	OBJC2_UNAVAILABLE;
	};
	
	// Property
	typedef struct objc_property *Property;
	typedef struct objc_property *objc_property_t; // 这个更常用
	// 可以通过class_copyPropertyList和protocol_copyPropertyList方法获取类和协议中的属性。返回的是属性列表，列表中每个元素都是一个objc_property_t指针。
	objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount);
	objc_property_t *protocol_copyPropertyList(Protocol *proto, unsigned int *outCount);
	
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
	2. 重定向，也叫Fast forwarding：若resolve方法返回NO，运行时就会移到下一步即"消息转发(Message Forwarding)"。如果目标对象实现了-forwardingTargetForSelector:，runtime这时就会调用这个方法，给你把这个消息转发给其他对象的机会。只要这个方法返回的不是nil和self，整个消息发送的过程就会被重启，当然发送的对象会变成返回的那个对象。否则就会继续Normal forwarding。这里叫Fast是为了区别下一步的转发机制，因为这一步不会创建任何新的对象，所以相对更快点。
		
		```
		- (id)forwardingTargetForSelector:(SEL)aSEL {
			if (aSelector == @selector(foo:)) {
				return otherObj;
			}
			return [super forwardingTargetForSelector:aSEL];
		}
		```
	3. 转发，也叫Normal forwarding：这一步是runtime最后一次挽救的机会，首先它会发送-methodSignatureForSelector:消息获得函数的参数和返回值类型，若返回nil则会发出-doesNotRecognizeSelector:消息，程序这时也就挂掉了。若返回了一个函数签名，runtime就会创建一个NSInvocation对象并发送-forwardInvocation:消息给目标对象。NSInvocation实际上就是对一个消息的描述，包括selector以及参数等信息。所以你可以在-forwardInvocation:里修改传进来的NSInvocation对象，然后发送-invokeWithTarget:消息给它，传进去一个新的目标。

		```
		// 在forwardInvocation:消息发送前，runtime系统会向对象发送methodSignatureForSelector:消息，并取得返回的方法签名用于生成NSInvocation对象。所以重写forwardInvocation:的同时也要重写methodSignatureForSelector:方法，否则会抛异常。
		- (void)forwardInvocation:(NSInvocation *)invocation {
			SEL sel = invocation.selector;
			if ([otherObj respondsToSelector: sel]) {
				[invocation invokeWithTarget:otherObj];
			} else {
				[self doesNotRecognizeSelector: sel];
			}
		}
		// 如果一个对象想要转发它接收的任何远程消息，它得给出一个方法标签来返回准确的方法描述methodSignatureForSelector:，这个方法会最终响应被转发的消息。从而生成一个确定的NSInvocation对象描述消息和消息参数。这个方法最终响应被转发的消息。
		- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
			NSMethodSignature *signature = [super methodSignatureForSelector:selector];
			if (!signature) {
				signature = [otherObj methodSignatureForSelector:selector];
			}
			return signature;
		}
		```
	4. 转发和继承相似，可用于为Objc添加一些多继承的效果。一个对象把消息转发出去，就好像它把另一个对象中的方法借过来或“继承”过来一样。消息转发弥补了Objc不支持多继承的性质，也避免了因为多继承导致单个类变得臃肿复杂。虽然转发可以实现继承的功能，但respondsToSelector:，isKindOfClass:，instancesRespondToSelector:和conformsToProtocol:等这类方法只会考虑继承体系，不会考虑转发链。

#### objc_msgForward
1. _objc_msgForward是IMP类型，用于消息转发的：当向一个对象发送一条消息，但它并没有实现的时候，_objc_msgForward会尝试做消息转发。`IMP msgForward = _objc_msgForward;`。
2. 如果手动调用objc_msgForward，将跳过查找IMP的过程，而是直接触发"消息转发"，进入如下流程：
	1. 第一步：+(BOOL)resolveInstanceMethod:(SEL)sel实现方法，指定是否动态添加方法。若返回NO，则进入下一步，若返回YES，则通过class_addMethod函数动态地添加方法，消息得到处理，此流程完毕。
	2. 第二步：在第一步返回NO时，就会进入-(id)forwardingTargetForSelector:(SEL)aSelector方法，这是运行时给我们的第二次机会，用于指定哪个对象响应这个selector。若返回nil，表示没有响应者，则会进入第三步。若返回某个对象，则会调用该对象的方法。
	3. 第三步：若第二步返回的是nil，则我们首先要通过-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector指定方法签名，若返回nil，则表示不处理。若返回方法签名，则会进入下一步。
	4. 第四步：当第三步返回方法签名后，就会调用-(void)forwardInvocation:(NSInvocation *)anInvocation方法，我们可以通过anInvocation对象做很多处理，比如修改实现方法，修改响应对象等。
	5. 第五步：若没有实现-(void)forwardInvocation:(NSInvocation *)anInvocation方法，那么会进入-(void)doesNotRecognizeSelector:(SEL)aSelector方法。若我们没有实现这个方法，那么就会crash，然后提示找不到响应的方法。到此，动态解析的流程就结束了。

#### 方法中的隐藏参数
1. 当objc_msgSend找到方法对应实现时，它将直接调用该方法实现并将消息中所有参数都传递给方法实现，同时它还将传递两个隐藏参数：
	1. 接收消息的对象(self所指向的内容，当前方法的对象指针)。
	2. 方法选择器(_cmd指向的内容，当前方法的SEL指针)。
	3. 这两个参数是在代码被编译时被插入方法实现中的。self是在方法实现中访问消息接收者对象的实例变量的途径。
2. 实际上super关键字接收到消息时，编译器会创建一个objc_super结构体`struct objc_super {id receiver; Class class;};`这个结构体指明了消息应该被传递给特定的父类。receiver仍然是self本身，当我们想通过[super class]获取父类时，编译器其实是将指向self的id指针和class的SEL传递给了objc_msgSendSuper函数。只有在NSObject类中才能找到class方法，然后class方法底层被转换为object_getClass()，接着底层编译器将代码转换为objc_msgSend(objc_super->receiver, @selector(class))，传入的第一个参数是指向self的id指针，与调用[self class]相同，所以我们得到的永远都是self的类型。

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
1. 不能向编译后得到的类中添加实例变量。因为编译后的类已经注册在runtime中，类结构体中的objc_ivar_list实例变量的链表和instance_size实例变量的内存大小已经确定，同时runtime会调用class_setIvarLayout或class_setWeakIvarLayout来处理strong weak引用。因此不能向存在的类中添加实例变量。
2. 可以向运行时创建的类中添加实例变量。运行时创建的类是可以添加实例变量，调用class_addIvar函数，但是得在调用objc_allocateClassPair之后，objc_registerClassPair之前。原理同上。

#### 让Category支持属性
1. 使用runtime实现

	```
	// 头文件
	@interface NSObject (test)
	@property (nonatomic, copy) NSString *name;
	@end
	
	// .m实现文件
	@implementation NSObject (test)
	// 定义关联的key
	static const char *key = "name";
	
	- (NSString *)name {
		// 根据关联的key获取关联的值
		return objc_getAssociatedObject(self, key);
	}
	
	- (void)setName:(NSString *)name {
		// 第一个参数：给哪个对象添加关联；第二个参数：关联的key，通过这个key获取；第三个参数：关联的value；第四个参数：关联的策略；
		objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	```




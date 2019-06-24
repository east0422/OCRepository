# 运行时
	runtime属于OC的底层实现，可以进行一些非常底层的操作，使用runtime在运行时可以动态创建一个类(KVO底层实现原理)，还可以动态的为某个类添加修改属性和方法及遍历类的所有成员和成员方法。使用时常引入<objc/message.h>和<objc/runtime.h>，message.h包含runtime.h。

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

#### method_exchangeImplementations
1. 可交换两个方法的实现，通常在load中使用。
2. 注意调用方法，避免方法交换后调用的实际上是自身方法而造成死循环。

	```
	Method urlWithStr = class_getClassMethod([NSURL class], @selector(URLWithString:));
	// eastURLWithString:方法中记得调用eastURLWithString:方法，若此处调用URLWithString:原始方法则会循环调用此方法造成死循环，两个方法在此处已经交换了。
	Method eastUrlWithStr = class_getClassMethod([NSURL class], @selector(eastURLWithString:));
	// 交换两个方法
	method_exchangeImplementations(urlWithStr, eastUrlWithStr);
	```




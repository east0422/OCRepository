# KVC


#### 简述
1. Key-Value-Coding(键值编码)是一种间接访问对象实例变量的机制，该机制可以不需要调用存取方法和变量实例就可以访问对象的实例属性。允许开发者通过Key名直接访问对象的属性，或者给对象的属性赋值，而不需要调用明确的存取方法。这样就可以在运行时动态地访问和修改对象的属性。而不是在编译时确定。
2. KVC中的基本调用包括valueForKey:和setValue:forKey:两个方法，它们以字符串的形式向对象发送消息，字符串(key)是关注属性的关键，方法中指定key若没用下划线会自动添加下划线。当属性有set,get方法时若forkey的key跟我们set方法的方法名一样(都没有下划线或都有下划线)，那么会优先调用set方法（get方法一样）。
3. KVC还支持指定路径，用点号隔开valueForKeyPath:及setValue:forKeyPath:，若向数组请求一个键值，它实际上会查询数组中的每个对象来查找这个键值，然后将查询结果打包到另一个数组中并返回给你。
4. KVC简单运算，可以应用一些字符做简单运算(sum、min、max、avg、count)。
5. KVC破坏封装性，不推荐使用。
6. 一个对象在调用setValue时，依次查找set<Key>，_set<Key>，setIs<Key>命名方法，若找到就调用该方法并将值传进去；没有发现简单的setter方法，但是accessInstanceVariablesDirectly类属性返回YES，则查找一个命名规则为_<key>、_is<Key>、<key>、is<Key>的实例变量。根据这个顺序，如果发现则将value赋值给实例变量；若还是没有就调用setValue:forUndefinedKey方法并默认抛出一个异常。
7. 一个对象在调用valueForKey:时，通过getter方法搜索实例，按照get<Key>, <key>, is<Key>, _<key>的顺序若找到则执行它返回结果(取回的是一个对象指针，则直接返回这个结果；如果取回的是一个对象指针，则直接返回这个结果；取回的是一个不支持NSNumber的基础数据类型，则通过NSValue进行存储并返回)；集合访问器方法可查看文档说明；accessInstanceVariablesDirectly返回YES，依照匹配模式 _<key>, _is<Key>, <key>, or is<Key>去匹配实例变量名称，如果有一个实例变量找到了,就返回这个实例变量的结果；若还是没有就会执行valueForUndefinedKey方法，默认产生一个NSUndefinedKeyException的异常，可重写该方法。
8. 集合运算符@count，@max，@min，@sum，@avg使用valueForKey或valueForKeyPath时不要忽略@。





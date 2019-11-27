# KVC


#### 简述
1. Key-Value-Coding(键值编码)是一种间接访问对象实例变量的机制，该机制可以不需要调用存取方法和变量实例就可以访问对象的实例属性。允许开发者通过Key名直接访问对象的属性，或者给对象的属性赋值，而不需要调用明确的存取方法。这样就可以在运行时动态地访问和修改对象的属性。而不是在编译时确定。
2. KVC中的基本调用包括valueForKey:和setValue:forKey:两个方法，它们以字符串的形式向对象发送消息，字符串(key)是关注属性的关键，方法中指定key若没用下划线会自动添加下划线。当属性有set,get方法时若forkey的key跟我们set方法的方法名一样(都没有下划线或都有下划线)，那么会优先调用set方法（get方法一样）。
3. KVC还支持指定路径，用点号隔开valueForKeyPath:及setValue:forKeyPath:，若向数组请求一个键值，它实际上会查询数组中的每个对象来查找这个键值，然后将查询结果打包到另一个数组中并返回给你。
4. KVC简单运算，可以应用一些字符做简单运算(sum、min、max、avg、count)。
5. KVC破坏封装性，不推荐使用。
6. 一个对象在调用setValue时，检查是否存在相应key的set方法，存在就调用set方法；set方法不存在就查找_key的成员变量是否存在，存在就直接赋值；若_key没找到，就查找相同名称的key，存在就赋值；若还是没有就调用valueForUndefinedkey和setValue:forUndefinedKey。




# 单例


#### 简述
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
	



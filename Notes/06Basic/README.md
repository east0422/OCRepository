# 基础知识点
	源代码—》编译预处理—》编译—》链接—》运行

#### 谓词NSPredicate
1. 谓词就是通过NSPredicate给定的逻辑条件作为约束条件完成对数据的筛选。cocoa中提供了NSPredicate类，指定过滤器的条件，将符合条件的对象保留下来。
2. 简单使用

	```
	// 定义谓词对象(对象中包含了过滤条件)
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age<%d", 30];
	// 使用&&进行多条件过滤 predicate = [NSPredicate predicateWithFormat:@"name='1' && age>40"];
	// 包含语句 predicate = [NSPredicate predicateWithFormat:@"self.name IN {'1','2','4'} || self.age IN {30,40}"];
	// 同理有还有以什么开头BEGINSWITH，以什么结尾ENDSWITH，包含CONTAINS，匹配多个字符like，一个字符?等
	// 使用谓词条件过滤数组中的元素，过滤之后返回查询的结果
	NSArray *arr = [persons filteredArrayUsingPredicate:predicate];
		
	```
		
#### 编译预处理指令
1. 在编译前进行解析处理的指令。
2. 所有编译预处理指令都是以#开头的。
3. 所有预编译处理指令都是不需要分号的。
4. 预处理指令可出现在程序的任何位置，它的作用范围是从它出现的位置到文件尾。习惯上尽可能将预处理指令写在源程序开头，这种情况下，它的作用范围就是整个源程序文件。

#### 宏定义
1. 宏名一般使用大写字母。
2. 程序中用双引号扩起来和注释中的宏名不会被替换。
3. 在预编译处理用字符串替换宏名时，不作语法检查，只是简单的字符串替换。只有在编译的时候才对已经展开宏名的源程序进行语法检查。
4. 宏名的有效范围从定义位置到文件结束。如果需要终止宏定义的作用域，可以用#undef命令。
5. 宏名和参数列表间不能有空格，否则空格后面的所有字符串都作为替换的字符串。
6. 宏定义不涉及存储空间的分配、参数类型匹配、参数传递、返回值问题；函数调用在程序运行时执行，而宏替换只在编译预处理阶段进行，所以带参数的宏比函数具有更高的执行效率。
7. 常用宏
	* __FILE__: 当前源文件名。
	* __LINE__:当前行号。
	* __FUNCTION__:当前函数名称。
	* __VA_ARGC__:可变参数。
	* _cmd: 代表着当前方法的SEL。 
8. 案例分析

	```
	// c代码
	#define MAX(X, Y) ((X) > (Y) ? (X) : (Y))
	int arr[5] = {1, 2, 3, 4, 5};
	int *p = &arr[0];
	int max = MAX(*p++, 1);
	printf("%d %d", max, *p); // 1 2
	// 浅析： p指针指向了数组arr的首地址，也就是第一个元素对应的地址，其值为1。*p++相当于*p, p++所以MAX(*p++, 1)相当于(*p++) > (1) ? (*p++) : (1) => (1) > (1) ? (*p++) : (1)第一个*p++的结果是1，但p所指向的值变成了2，由于1 > 1为假，所以最终max的值为1，而后面的（*p++)也就不会执行，因此p所指向的地址对应的值就是2。若上面的*p++改成*(++p)的话(*++p) > (1) ? (*++p) : (1) => (2) > (1) ? (*++p) : (1) => max = *++p => *p = 3, max = 3。
	```

#### define定义的宏和const定义的常量有什么区别
1. define定义宏的指令，程序在预处理阶段将用#define所定义的内容只是进行了替换。因此程序运行时，常量表中并没有用#define所定义的宏，系统并不为它分配内存，而且在编译时不会检查数据类型，出错的概率更大一些。
2. const定义的常量，在程序运行时是存放在常量表中，系统会为它分配内存，而且在编译时会进行类型检查。

#### #include, #import, @class
1. 使用#include <文件名>直接到c语言库函数头文件所在目录中寻找文件；而#include “文件名”系统会先在源程序当前目录下寻找，若找不到，再到操作系统的path路径中查找，最后才到c语言库函数头文件所在目录中查找。
2. 使用#include与#import效果相同，只是后者不会引起交叉编译，确保头文件只会被导入一次。
3. 使用#import会包含这个类的所有信息，包括变量和方法，而@class只是告诉编译器，其后面声明的名称是类的名称，至于这些类是如何定义的，暂时不用考虑，后面会再告诉你。
4. 若有很多个头文件都#import了同一个文件，或者这些文件以此被#import，那么一旦最开始的头文件稍有改动，后面引用到这个文件的所有类都需要重新编译一遍，效率是比较低的。
5. 能在实现文件中#import就不在头文件中#import，在头文件中尽量使用@class。

#### 全局变量和静态变量
1. 全局变量在声明源文件之外使用需要extern引用一下；静态变量使用static来修饰。
2. 两者都是存储在静态存储区，非堆栈上，它们与局部变量的存储分开。
3. 两者都是在程序编译或加载时由系统自动分配的，程序结束时消亡。
4. 全局变量在整个程序的任何地方均可访问，而静态变量相当于面向对象中的私有变量，它的可访问性只限定于声明它的那个源文件，即作用仅局限本文件中。

#### static关键字
1. 保持变量内容的持久，全局变量和static变量都存储在静态存储区，程序开始运行就初始化，只初始化一次。static定义的这一行代码仅仅会执行一次。
2. 函数体内static变量的作用范围为该函数体，不同于auto变量，该变量的内存只被分配一次，因此其值在下次调用时仍维持上次的值。默认初始化为0，在静态数据区，内存中的所有字节都是0x00，全局变量和static变量都是默认初始化为0。
3. 在模块内的static全局变量可以被模块内所有函数访问，但不能被模块外其它函数访问；在模块内的static函数只可被这一模块内的其它函数调用，这个函数的使用范围被限制在声明它的模块内。
4. 在类中的static成员变量属于整个类所拥有，对类的所有对象只有一份拷贝；在类中的static成员函数属于整个类所拥有，这个函数不接收this指针，因而只能访问类的static成员变量。

#### volatile关键字
1. 特点：
	* 优化器在用到这个变量时必须每次都小心地重新读取这个变量的值，而不是使用保存在寄存器里的备份。
	* 当一个变量被volatile修饰时，任何线程对它的写操作都会立即刷新到主内存中，并且会强制让缓存了该变量的线程中的数据清空，必须从主内存重新读取最新数据。
	* volatile修饰之后并不是让线程直接从主内存(简单认为是堆内存)中获取数据，依然需要将变量拷贝到工作内存(简单认为是栈内存)中。
2. 使用例子：
	* 并行设备的硬件寄存器(如：状态寄存器)。
	* 一个中断服务子程序中会访问到的非自动变量(Non-automatic-variables)
	* 多线程应用中被几个任务共享的变量。

#### NSString
1. 通过类名的字符串形式实例化对象  Class class = NSClassFromString(@“Person”);   Person *person = [[class alloc] init];
2. 将类名变成字符串   Class class = [Person class];   NSString *className = NSStringFromClass(class);
3. 通过方法的字符串形式实例化方法  SEL selector = NSSelectorFromString(@“setName:”); 
  [person performSelector:selector withObject:@“Mike”);
4. 将方法变成字符串   NSStringFromSelector(@selector(setName:));
5. substringFromIndex从哪个索引开始截取到字符串的末尾(包含索引位置字符)，  开始位置索引为0。
6. substringToIndex从开始位置截取到索引位置(不包含索引位置字符)。
7. [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];把UTF8编码的字符串，编码成为URL中可用的字符串，中文会转换为%形式字符串，常用于有中文路径。
8. [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];把URL中可用的字符串，编码成为UTF8编码的字符串。
9. 通过字面的方式(NSString *str = @"abc")创建出来的对象保存在常量区，通过对象方法(NSString *str = [[NSString alloc] initWithUTF8String:"abc"])和类方法(NSString *str = [NSString stringWithFormat:@"abc"])创建出来的对象保存在堆中。

#### 集合
1. 就是能用来容纳OC对象的容器。NSArray,NSDictionary等都是。
2. 只要将一个对象添加到集合中，这个对象计数器就会加1(做一次retain操作)。
3. 只要将一个对象从集合中移除，这个对象计数器就会减1(做一次release操作)。
4. 如果集合被销毁了，集合里面的所有对象计数器都会减1(做一次release操作)。

#### NSSet、NSArray、NSDictionary区别
1. NSSet:
	* 无序集合。
	* 在内存中存储的地址是不连续的。
	* 添加进去的元素是不可重复的。
2. NSArray:
	* 有序集合。
	* 在内存中存储的地址是连续的，添加的元素是可重复的。
	* 支持通过下标访问元素。
	* 如果想知道一个元素是否存在这个数组当中的话，则需要遍历整个数组一个个去判断，效率低下。
3. NSDictionary:
	* 无序集合。
	* 数据存储方式是key value键值对方式进行存储的。
	* key在整个NSDictionary里是唯一的，如果key发生重复，那么后添加的元素会覆盖之前的。
4. 都属于不可变集合类，在创建完集合类后就不能够对他们进行修改，在集合类里只能添加对象元素不能添加基本数据类型。
5. 数组结构，查询快，插入慢，每次插入一个元素后边所有角标加1。链表数据结构，查询慢，插入快，手拉手询问形式。

#### NSArray数组排序
1. selector选择器  array = [array sortedArrayUsingSelector: @selector(compare:)];
2. 比较器  array = [array sortedArrayUsingComparator:^NSComparisonResult(Person *p1, Person *p2){return [p1.name compare:p2.name];}];。
3. 属性描述器  NSSortDescriptor *desc1 = [NSSortDescriptor sortDescriptorWithKey:@“name” ascending: YES];  NSSortDescriptor *desc2 = [NSSortDescriptor sortDescriptorWithKey:@“age” ascending: YES];  array = [array sortedArrayUsingDescriptor:@[desc1, desc2]];。
4. 构造数组时不要在数组中间放nil，nil表示数组结束了，数组中可放不同类型对象，但建议放同一种类型对象。

#### NSObject
1. 基类，所有类的祖先类，让子类具有创建对象的能力。
2. 类的声明以@interface开头，以@end结尾；类的实现以@implementation开头以@end结尾。
3. 若一个类只有声明没有实现，那么这个类在链接的时候就报错，如同C中只有声明没有定义一般。
4. 内部定义常用方法   - (BOOL)isKindOfClass:(Class)aClass;判断是否为aClass或者aClass子类的实例。
  - (BOOL)isMemberOfClass:(Class)aClass;判断是否为aClass的实例(不包括aClass的子类)。
  - (BOOL)conformsToProtocol:(Protocol *)aProtocol;判断对象是否实现了aProtocol协议。
  - (BOOL)respondsToSelector:(SEL)aSelector;判断对象是否拥有参数提供的方法。
  - (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:    (NSTimeInterval)delay;延迟调用  参数提供的方法，方法所需参数用withObject传    入。
   
#### 创建对象步骤
1. 开辟内存空间。
2. 初始化参数。
3. 返回内存地址值。

#### [类名 new]作用
1. 为该类创建一个对象并在堆中分配内存。
2. 初始化成员变量。
3. 返回指向刚刚创建出来的对象的指针。

#### NSLog与printf对比
1. printf是C语言提供的，在stdio.h头文件中；NSLog是Foundation框架提供的在NSObjCRuntime.h中。
2. NSLog包含日志输出日期以及对应的应用程序名称。
3. NSLog自动换行，末尾\n是无效的。
4. NSLog中的格式字符串不是普通C语言字符串，NSString对象@“”它是一个NSString对象的字面量表示。
5. printf中所有占位符在OC中都是支持的。
6. NSLog新增了格式符%@用于输出对象。

#### 类方法与对象方法
1. 类方法声明和定义以+开头，对象方法以-开头。
2. 类方法只能通过类名调用它，对象方法只能通过对象调用。
3. 类方法中不能访问成员变量，对象方法可以直接访问成员变量。
4. 类方法中不可直接调用对象方法，可通过传入参数和局部变量来调用对象方法；对象方法可以调用对象方法，也可以通过类名调用类方法。
5. 类方法比对象方法执行速度更快，更节省内存空间，因为类方法是通过类对象调用的，可以通过类名直接找到，类对象在程序已启动就被创建并初始化，在整个程序运行期间类对象只有一个，不需要开辟存储空间。而对象方法必须通过对象调用，需要通过isa指针找到类对象，然后才能找到对象方法。
6. 类方法和对象方法可以重名。

#### 继承
1. 类方法是可继承可覆盖的。
2. 子类中不能定义和父类同名的成员变量。
3. private成员变量只能在定义类中访问。

#### Protocol协议
1. 一序列方法的列表，其中声明的方法可以被任何类实现，这种模式通常称为代理模式。
2. 任何类只要遵守了Protocol，就相当于拥有了Protocol的所有方法声明。
3. 协议中方法默认是@required必须实现的,遵守该协议的类中不实现会有警告，也可通过@optional说明为可选非必需实现，遵守该协议类中不实现不会有警告，这两个关键字是在OC2.0后加入的语法特性，若不注明则默认是@required的。在@required后面的都是@required的直到遇到@optional，在@optional后面的都是@optional直到遇到@required，与成员变量访问权限类型相似。
4. 一个协议可遵守其他多个协议。
5. 建议每个新的协议都要遵守NSObject协议。
6. 通过id<协议名称>定义出来的指针变量可以指向任意实现这个协议的类的实例对象，通过该变量可以调用协议中声明的方法，从而实现多态。
7. 可以使用conformsToProtocol判断某个类是否实现了某个protocol。

#### 分类(category)
1. 不需要通过增加子类而增加现有类的行为(方法), 且类目中的方法与原始类方法基本没有区别。
2. 可以访问原始类的实例变量，但不能添加实例变量，只能添加方法。想添加变量可通过继承创建子类。分类可以访问原来类中的成员变量。
3. 可实现原始类的方法，但不推荐，因为它是直接替换掉原来的方法，这么做的后果是再也不能访问原来的方法。覆盖原始类方法后，原始类的方法没办法调用。
4. 名称：原有类的名称(分类名称)，文件名称：原有类的名称+分类名称。
5. 分类中使用@property只能生成getter与setter方法的声明，不能生成getter与setter方法的实现和成员变量。
6. 若多个分类中实现了相同的方法，最后将使用最后编译的那个分类中的方法(Build Phases -> Compile Sources从上往下依次是先到后参加编译，因此下面分类中的方法会覆盖掉上面分类中同名的方法，最下面的最后编译)。
7. 调用优先级：分类 -> 原始类 -> 父类。

#### 扩展(extension)
1. 类扩展是没有名称的，直接在类后加括号，相对于分类缺少括号中名称。
2. 类扩展可以扩充方法和成员变量。
3. 扩展一般写在.m文件中，用来扩充私有的方法和成员变量。

#### 类的私有方法
1. 直接在.m文件中写方法实现，不要在.h文件中进行方法声明。
2. 在.m文件中定义一个category,在category中声明一些方法，然后在@implementation跟@end之间做方法实现。

#### +load
1. 在程序启动的时候会加载所有的类和分类，并调用所有类和分类的+load方法。
2. 先加载父类，再加载子类；也就是先调用父类的+load，再调用子类的+load。
3. 先加载原始类，再加载分类Category。
4. 不管程序运行过程中有没有用到这个类，都会调用+load加载。

#### +initialize
1. 在第一次使用某个类时(比如创建对象等)，就会调用一次+initialize方法。
2. 一个类只会调用一次+initialize方法，先调用父类的，再调用子类的。

#### dealloc
1. 如果是ARC记得不能再调用[super dealloc];

#### 方法存储位置
1. 每个类的方法列表都存储在类对象中。
2. 每个方法都有一个与之对应的SEL类型的对象。
3. 根据一个SEL对象就可以找到方法的地址，进而调用方法。
4. SEL类型的定义typedef struct objc_selector *SEL; 

#### self
1. self在对象方法中，它是调用这个方法的对象，可以访问其它对象方法。
2. self在类方法中，它是调用这个方法的类，可以访问其它类方法。

#### SEL
1. 特点： 是一种代表着方法的签名数据类型，也称它是一个选择器。可用作定义普通的变量，方法行参/实参，方法返回值。
2. 基本使用：
	1. 对象创建SEL s = @selector(test); SEL s2 = NSSelectorFromString(@“test”);
	2. 对象转为NSString对象 NSString *str = NSStringFromSelector(@selector(test));
	3. 检测对象是否实现了test方法  Person *p = [Person new];   [p respondsToSelector:@selector(test)];
	4. 调用对象的test方法[p performSelector:@selector(test)];

#### id和instancetype
1. id类型是万能指针，能作为参数，方法的返回类型。
2. instancetype只能作为方法的返回类型，并且返回的类型是当前定义类的类类型。

#### sprintf、strcpy以及memcpy函数的区别
1. sprintf函数主要用来实现(字符串或基本数据类型)向字符串的转换功能，若源对象是字符串，并且指定%s格式符，也可实现字符串拷贝功能。是格式化函数，将一段数据通过特定的格式，格式化到一个字符串缓冲区中去，sprintf格式化函数的长度不可控，有可能格式化后的字符串会超出缓冲区的大小，造成溢出。
2. strcpy函数操作的对象是字符串，完成从源字符串到目的字符串的拷贝功能。它的函数原型为strcpy(char dst, const char src);将src开始的一段字符串拷贝到dst开始的内存中去，结束的标志符号为'\0'，由于拷贝的长度不是由我们自己控制的，所以这个字符串拷贝很容易出错。
3. memcpy函数是内存拷贝，实现将一个内存块的内容复制到另一个内存块这一功能。内存块由其首地址以及长度确定，因此memcpy的操作对象适用于任意数据类型，只要能给出对象的起始地址和内存长度信息、并且对象具有可操作性即可。它的函数原型为memcpy(char dst, const char src, unsigned int len);将长度为len的一段内存，从src拷贝到dst中去，这个函数的长度可控，但是会有内存读写错误(比如len的长度大于要拷贝的空间或目的空间)。鉴于memcpy函数等长拷贝的特点以及数据类型代表的物理意义，memcpy函数通常限于同种类型数据或对象之间的拷贝，其中当然也包括字符串拷贝以及基本数据类型的拷贝。
4. 对于字符串拷贝三个函数都可以实现，只是其实现的效率和使用方便程度不同
	* strcpy效率高且调用方便(通常最合适选择)。
	* sprintf要额外指定格式符并且进行格式转化，麻烦且效率不高。
	* memcpy虽然高效，但是需要额外提供拷贝的内存长度这一参数，易错且使用不便；并且如果长度指定过大的话(最优长度是源字符串长度+1)，还会带来性能的下降。其实strcpy函数一般是在内部调用memcpy函数或者用汇编直接实现的，以达到高效的目的。因此，使用memcpy和strcpy拷贝字符串在性能上应该没有什么大的差别。
	* 对于非字符串类型的数据的复制来说，strcpy和sprintf一般就无能为力了，可是对memcpy却没有什么影响。但是，对于基本数据类型来说，尽管可以用memcpy进行拷贝，由于有赋值运算符可以方便且高效地进行同种或兼容类型的数据之间的拷贝，所以这种情况下memcpy几乎不被使用。memcpy的长处是用来实现(通常是内部实现居多)对结构或数组的拷贝，其目的是高效或使用方便或两者兼有。

#### @property
1. 属性@property的本质是ivar(实例变量)+getter(取方法)+setter(存方法)。
2. ivar、getter及setter是编译器自动合成的，通过@synthesize关键字指定，若不指定，默认为@synthesize propertyName=_propertyName；若手动实现了getter/setter方法则不会自动合成。生成getter方法时，会判断当前属性名是否有下划线_，比如声明属性为@property (nonatomic, copy) NSString *_name;那么所生成的成员变量名就会变成__name，如果我们要手动生成getter方法就要判断是否以_开头了。命名规范是不允许声明属性是使用_开头的，不规范的命名在使用runtime时会带来很多的不便。
3. 在protocol协议中使用@property只会生成setter和getter方法声明，在协议中使用属性的目的是希望遵守该协议的对象能实现该属性。
4. 在category类别中使用@property也是只会生成setter和getter方法的声明，若我们真的需要给category增加属性的实现，需要借助于运行时的两个函数objc_setAssociatedObject和objc_getAssociatedObject。

#### 其他
* 成员变量是在{}中定义的，属性是使用@property定义的，@property会生成下划线开头的成员变量。



# Masonry


#### Masonry
1. 开源地址 [https://github.com/SnapKit/Masonry](https://github.com/SnapKit/Masonry)。
2. 底层原理分析：
	1. 链式block响应。


#### Masonry.h
1. 在该头文件中引入其他头文件使得使用该框架时只需引入该头文件即可而不必引入一堆的头文件。

#### MASUtilities.h
1. 定义统一宏适配不同平台，后期有需要改动时只需要改动宏定义就行。
2. 定义MASAttachKeys宏便于同时按指定规则对多个变量设置mas_key。
3. NSAssert是一个预处理宏，主要作用当condition为false时捕获一个错误让程序崩溃同时报出描述错误提示。Build Settings -> Apple Clang-Preprocessing -> Enable Foundation Assertions默认Debug为Yes，Release为No。为No时任何调用NSAssert的地方都被空行替换。
4. 使用stdarg.h头文件中宏定义
	
	```
	// 1、 va_start获取可变参数列表的第一个参数的地址
	typedef char *va_list;
	// list是类型为va_list的指针，param1是可变参数最左边的参数即第一个可变参数
	#define va_start(list, param1) (list = (va_list)&param1 + sizeof(param1))
	
	// 2、va_arg获取可变参数的当前参数，返回指定类型并将指针指向下一参数
	// mode参数描述了当前参数的类型；这个-1操作是返回当前指针前一个值
	#define va_arg(list, mode) ((mode *)(list += sizeof(mode)))[-1]
	
	// 3、va_end清空va_list可变参数列表
	#define va_end(list) (list = (va_list)0)
	
	// 4、上述sizeof()只是为了说明工作原理，实际实现中，增加的字节数需保证为int的整数倍
	#define _INTSIZEOF(n) ((sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1))
	
	// 5、C语言中函数参数是存储在栈中的，函数参数从右往左依次入栈 
	```

#### View+MASAdditions
1. mas_(make/update/remake)Constraints方法中第一行执行代码就是self.translatesAutoresizingMaskIntoConstraints = NO;(使用自动布局需要关闭该属性)。以视图自己为参数生出一个MASConstraintMaker类对象constraintMaker，依据update/remake标记constraintMaker对象的updateExisting/removeExisting为YES，将constraintMaker作为参数执行block，最后执行[constraintMaker install]完成约束的生成/更新/删除所有再重新生成。	
2. 使用运行时给MASView关联mas_key属性(动态添加mas_key的getter和setter方法实现)。
3. mas_closestCommonSuperview获取最近共同父视图控件，依次获取当前控件A父控件直到为nil和要对比控件B比较看是否为同一个控件，若是返回控件，若不是则赋值控件B父控件给B继续前面操作直到B为nil，该算法时间复杂度为O(m*n)。可查阅"最近公共祖先"对比不同算法，择优使用。
4. 在扩展类中为原有类添加只读前缀为mas_的只读属性，在实现中手动实现只读属性的getter方法。因为扩展类中的@property属性不会生出setter/getter实现方法和私有的成员变量，所以需要自己手动实现对应的方法和成员变量。若没有实现则在调用时会出错。

#### View+MASShorthandAdditions.h
1. 宏定义

	```
	// 一个#号：表示加双引号；kToStr1(111)等价于"111"是一个C字符串，kToStr2(111)等价于@"111"是一个OC字符串。
	#define kToStr1(x) #x
	#define kToStr2(x) @""#x 或 #define kToStr2(x) @#x
	// 两个##号：表示连接；kConnect(123, 456)等价于123456。
	#define kConnect(x, y) x##y
	// #@：表示加单引号；kToChar(a)等价于'a'。
	#define kToChar(x) #@x
	```
2. 定义和实现都在.h文件中。若想使用简化版(即不使用mas_前缀)则在引入该框架前定义一下MAS_SHORTHAND(#define MAS_SHORTHAND)。

#### ViewController+MASAdditions
1. 实质是UIViewController类扩展，为UIViewController类在iOS8.0到iOS11.0间增加了一些类似mas_topLayoutGuide只读属性。
2. (#pragma clang diagnostic)常用用法

	```
	// clang诊断push
	#pragma clang diagnostic push
	// 忽略相关命令对应的警告
	#pragma clang diagnostic ignored "-相关命令"
	// 将相关命令对应的警告识别为error
	// #pragma clang diagnostic error "-相关命令"
		
	// 常用相关命令有
	//	-Wdeprecated-declarations     废弃的方法
	// -Wincompatible-pointer-types  指针类型不匹配
	// -Warc-retain-cycles           循环引用
	// -Wunused-variable             未使用的变量
	// -Warc-performSelector-leaks   内存泄漏
	
	// 自己的code
	
	// clang诊断pop，如果不pop，后面代码也会和上面code同样处理
	#pragma clang diagnostic pop
	```

#### NSArray+MASAdditions
1. NSArray类扩展，为NSArray类添加mas_makeConstraints:等方法。
2. NS_NOESCAPE用于修饰方法中的block类型参数，作用是告诉编译器参数block在方法返回之前就会执行完毕，而不是被保存起来在之后的某个时候再执行，编译器知道之后就会相应地做一些优化(例如去掉一些多余的对self的捕获、retain、release操作，因为block的存活范围仅限于本方法内，没有必要再在block内保留self了)。
3. mas_(make/update/remake)Constraints:方法首先生出一个NSMutableArray对象constraints，然后依次遍历数组自己中元素，若元素类型是[MAS_VIEW class]类型或其子类型则调用在扩展类中为MAS_VIEW添加的对应方法获取返回值然后调用constraints的addObjectsFromArray将返回值添加到constraints中最后返回constraints，否则的话断言报错。
4. mas_commonSuperviewOfViews方法依次拿出数组中类型是[MAS_VIEW class]或其子类型元素，然后调用mas_closestCommonSuperview:方法获取最近公共父组件，最后返回数组中所有MAS_VIEW类或其子类元素的最近共同父组件。可以考虑在if (previousView)语句块中添加if (commonSuperview)判断，如果commonSuperview为nil则说明至少有两个MAS_VIEW没有共同祖先故可直接返回不用再遍历剩余的数组元素。
5. mas_distributeViewsAlongAxis:(MASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;依据axisType值是水平/垂直对数组元素进行排列，对数组中第一个元素left/top约束相对父视图偏移leadSpacing，最后一个元素right/bottom约束相对父视图偏移-tailSpacing(是负值)，其他元素约束设置width/height等于前一个元素，left/top相对前一个元素偏移fixedSpacing。该方法确保leadSpacing和tailSpacing固定，各子视图间隔固定，子视图大小(宽/高)会相对变化。
6. mas_distributeViewsAlongAxis:(MASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;和上一个方法类似排列数组中各元素，区别是子视图大小(宽/高)固定等于fixedItemLength，bottom/right是计算出来的(计算好像有点问题，后续查证)，而且所有子视图约束都是相对于父视图。

#### NSArray+MASShorthandAdditions.h
1. 与View+MASShorthandAdditions.h类似，只不过针对的是NSArray，若不想数组中使用前缀mas_同样在引入前宏定义MAS_SHORTHAND即可。

#### MASConstraint
1. 链式创建一个或一组约束，定义很多返回自身的块方法。
2. 宏定义部分mas_方法使用，使用#ifdef MAS_SHORTHAND_GLOBALS判断是否再次使用宏定义。使用MAS_SHORTHAND_GLOBALS实质还是调用自身，只是对参数做了MASBoxValue解码操作。
3. 使用AutoboxingSupport分类实现宏定义中使用方法。
4. MASConstraint的init方法中添加了一个NSAssert断言不能直接使用MASConstraint的init方法而只能使用其子类并实现代理方法和未实现的方法(不能直接使用也是因为有部分方法和代理协议方法未实现)。
5. 关系约束实质调用的是equalToWithRelation；优先级约束实质调用的是priority；left等方法实质是先调用addConstraintWithLayoutAttribute(该类中未实现，需要子类实现)添加对应的约束，然后返回自身；with和and只是一个连接方便阅读而已实质只是返回自身。
6. setLayoutConstantWithValue会依据参数value的objCType类型设置不同offset，注意strcmp(value.objCType, @encode(CGPoint)) == 0类型判断比较及[value getValue:&point]获取值。

#### MASConstraint+Private.h
1. 使用扩展为MASConstraint增加属性(包括MASConstraintDelegate代理属性)和方法。
2. 在引用协议前使用协议使用@protocol DelegateName;进行协议的声明，协议声明通常使用于当前文件中定义协议在使用协议后。
3. 使用Abstract分类添加两个方法。
4. 定义MASConstraintDelegate协议当约束需要被其他约束替换时通知代理。

#### MASCompositeConstraint
1. MASConstraint子类并添加了-(id)initWithChildren:(NSArray *)children;方法，方法实现中将children中所有约束的delegate都指向了自己。
2. 在实现文件扩展中添加了mas_key和childConstraints属性，并遵循了MASConstraintDelegate协议。
3. multipliedBy/dividedBy/priority/equalToWithRelation等方法都是依次遍历childConstraints约束进行对应的操作最后返回自身。

#### MASViewAttribute
1. 继承NSObject，定义了view、item、layoutAttribute三个只读属性，两个初始化方法，属性是否为大小属性(如果layoutAttribute为NSLayoutAttributeWidth或NSLayoutAttributeHeight则为YES)方法。

#### MASViewConstraint
1. 继承MASConstraint并遵循NSCopying协议，定义了firstViewAttribute和secondViewAttribute两个MASViewAttribute类型的只读属性。
2. 在实现文件中为MAS_VIEW添加一个MASConstraints分类，定义一个NSMutableSet类型的只读属性mas_installedConstraints，使用运行时添加到MAS_VIEW上(因为是集合类型所以只绑定了对应的getter方法，若获取为nil则创建一个并绑定，后面只需对集合进行增删元素等操作)。
3. 实现文件扩展中重定义了secondViewAttribute属性，并设为可读写，还定义了installedView等其他属性。
4. 其他主要功能方法有待深入研究。

#### MASConstraintMaker
1. 继承NSObject，使用枚举类型定义MASAttribute，使用位偏移方便多个值组合。
2. 定义MASConstraint类型的只读属性left等，还定义了一些其他属性和方法。
3. 遵循MASConstraintDelegate协议，扩展中添加了view和constraints属性。
4. 其他主要功能方法有待深入研究。

#### MASLayoutConstraint
1. 继承NSLayoutConstraint，只定义了一个mas_key属性。

#### NSLayoutConstraint+MASDebugAdditions
1. NSLayoutConstraint分类，主要是定义一些似有方法，重写了description方法便于调试。


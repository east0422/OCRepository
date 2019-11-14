# UITableView
	继承于UIScrollView，默认垂直滚动，性能极佳。
    
#### 常用使用步骤
1. 设置数据源和代理，实现数据源和代理协议方法(可提前注册cell)。
2. 自定义cell(纯代码)。
	1. 重写initWithFrame:(最好也重写initWithStyle:reuseIdentifier:外面注册后调用dequeueReusableCellWithIdentifier只会调用initWithStyle)。
	2. 定义子视图初始化方法，在上initWithFrame:和initWithStyle:reuseIdentifier:中调用它进行子视图的初始化。
	3. 重写layoutSubviews进行子视图布局。
	4. 重写模型，设置cell子视图控件显示值。
3. 取出cell进行数据赋值。

#### dequeueReusableCellWithIdentifier使用注意点
1. 可以先注册再使用，正确注册后再使用都会返回一个非nil的cell。
2. 纯代码创建的自定义cell，若先注册再通过dequeueReusableCellWithIdentifier:获取会调用initWithStyle: reuseIdentifier:方法而不会调用initWithFrame:，所以纯代码创建的自定义cell通常将子视图初始化提取为一个方法在上两个方法中调用。
3. 对于使用xib创建的自定义cell，注册需要使用registerNib:forCellReuseIdentifier:而不是registerClass:forCellReuseIdentifier:，同时在cell实现文件中需要通过NSBundle加载cell。
	
	```
	// 提前注册一个table cell类，通常在viewDidLoad中
	// 纯代码创建cell在vc中注册然后使用dequeueReusableCellWithIdentifier获取会调用initWithStyle: reuseIdentifier:方法而不是使用initWithFrame:。如果未注册使用dequeueReusableCellWithIdentifier则会调用initWithFrame:。
	[tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"identifier"];
	// 如果是xib则需要使用registerNib
	// UINib *nib = [UINib nibWithNibName:@"xibname" bundle:[NSBundle mainBundle]];
	// [self.tableView registerNib:nib forCellReuseIdentifier:@"identifier"];
	
	// 后面使用，通常在数据源代理方法tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath中使用显示cell内容
	// 如果缓存池中有相同identifier的cell则取出来，如果没有的话就使用前面注册的创建一个新的。
	[tableView dequeueReusableCellWithIdentifier:@"identifier"];
	```
	
#### UITableViewCell重用机制
1. 一个UITableView中有许多需要显示的cell，但我们不可能每个都浏览到，若我们把这些数据全部都加载进去可能会造成内存的负担。所能显示的区域通常只有一个屏幕的大小，那么屏幕之外的信息是不需要一次性全都加载完的，只有当我们滑动屏幕需要浏览时才需要加载进来，因此就有了UITableViewCell的重用机制。
2. 重用机制实现了数据和显示的分离，并不是为每个数据创建一个UITableViewCell，只创建屏幕可显示最大的cell个数+1，然后去循环重复使用这些cell，既节省空间又达到我们需要显示的效果。
3. 这种机制下系统默认有一个可变数组NSMutableArray *visibleCells用来保存当前显示的cell，还有一个可变字典NSMutableDictionary *reusableTableCells用来保存可重复利用的cell(用字典是因为可重用的cell有不止一种样式，需要根据它的reuseIdentifier重用标识符来查找是否有可重用的该样式的cell)。
4. 当数据过多，整个屏幕的cell显示不完全时cellForRowAtIndexPath执行情况为：
	 1. 先执行[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]创建整个屏幕能显示的cell数+1的cell(当拖动UITableView第一个cell没有移出屏幕，最下面的cell就已经存在时)，并指定相同或不同标识符identifier。把创建出屏幕能显示的cell全部都加入到visibleCells数组中(最后一个创建的先不加入数组)，reusableTableCells为空。
	 2. 当拖动屏幕时，顶端cell移出屏幕并加入到reusableTableCells字典中，键为identifier，并把之前已经创建但还未加入到visibleCells的cell加入到visibleCells数组中。
	 3. 当接着拖动时，因为reusableTableCells中已有值，当需要显示新cell，cellForRowAtIndexPath再次被调用，执行[tableView dequeueReusableCellWithIdentifier:identifier]，返回一个标识符为identifier的cell。该cell移出reusableTableCells后加入到visibleCells；顶端cell移出visibleCells并加入到reusableTableCells。如果reusableTableCells数组中没有找到identifier类型的cell则再次重新alloc一个。
5. iOS6之后系统加入了一种单元格注册的方法[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier]。该方法作用是当从重用队列中取cell时，若没有则系统会帮我们创建给定类型的cell，若有则直接重用，这种方式cell的样式为系统默认样式。只需在tableView初始化时注册一下然后就可以在cellForRowAtIndexPath中直接使用[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];获取cell。
	
#### 自定义模型使用setValuesForKeysWithDictionary
1. 注意点：
	1. 实现一个setValue:forUndefinedKey:以免模型中没有属性和字典中key对应而报错。
	2. 字典中key关键子可以在模型中使用一个别名然后通过setValue:forUndefinedKey:或setValue:forKey:方法依据对应key值进行特殊赋值。
	3. 一些字典数组需要一一遍历出来封装成新的对象数组再赋值给模型数组属性。
	4. 字典中嵌套字典也需要单独将其提取出来封装成新的对象再赋值给模型对象属性。
	5. 对于多层嵌套的依此上述。
2. 示例代码
	```
	// PersonModel.h
	#import <Foundation/Foundation.h>
	@class Birthday;
	
	// 人的模型
	@interface PersonModel : NSObject
	@property (nonatomic, copy) NSString *name; // 人的姓名
	@property (nonatomic, copy) NSString *age; // 人的年龄
	@property (nonatomic, strong) Birthday *birth; // 生日模型
	@property (nonatomic, copy) NSString *ID; // 人的ID，实际key为id关键字
	@property (nonatomic, strong) NSArray *subs; // 成绩数组，其中数组的每一个元素又是一个model(subjectModel)
	+ (instancetype)initWithDic:(NSDictionary *)dic;
	@end
	
	// 生日模型(年/月/日)
	@interface Birthday : NSObject
	@property (nonatomic, copy) NSString *year;
	@property (nonatomic, copy) NSString *month;
	@property (nonatomic, copy) NSString *day;
	+ (instancetype)initWithDic:(NSDictionary *)dic;
	@end
	
	// 科目模型(学科名/成绩)
	@interface SubjectModel : NSObject
	@property (nonatomic, copy) NSString *subName;
	@property (nonatomic, copy) NSString *grade;
	+ (instancetype)initWithDic:(NSDictionary *)dic;
	@end
	
	
	// PersonModel.m
	#import "PersonModel.h"

	@implementation PersonModel
	+ (instancetype)initWithDic:(NSDictionary *)dic {
		PersonModel *personModel = [[PersonModel alloc] init];
		// 实质还是调用setValue:forKey:
    	[personModel setValuesForKeysWithDictionary:dic];
    	return personModel;
	}
	
	// 对特殊类型需要单独处理
	- (void)setValue:(id)value forKey:(NSString *)key{
	    [super setValue:value forKey:key]; // 必须调用父类方法
	    if ([key isEqualToString:@"birth"]) { // 特殊字符处理
	        self.birth = [Birthday initWithDict:value]; // 模型嵌套模型
	    }
	    if ([key isEqualToString:@"subs"]) { // 特殊字符处理
	        NSMutableArray *subArr = [NSMutableArray array];
	        for (NSDictionary *dic in value) {
	            // 数组的每一元素是一个SubjectModel 模型
	            [subArr addObject:[SubjectModel initWithDict: dic]];
	        }
	        self.subs = subArr;
	    }
	}
	
	// 未标识key, 防止意外崩溃
	- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
		if ([key isEqualToString:@"id"]) { // id为关键字
        self.ID = value;
    	} else {
        NSLog(@"UndefinedKey:%@", key);
    	}
	}
	@end
	
	@implementation Birthday
	+ (instancetype)initWithDic:(NSDictionary *)dic {
		Birthday *birthday = [[Birthday alloc] init];
    	[birthday setValuesForKeysWithDictionary:dic];
    	return birthday;
	}
	
	- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	    NSLog(@"UndefinedKey:%@", key);
	}
	@end
	
	@implementation SubjectModel
	+ (instancetype)initWithDic:(NSDictionary *)dic {
		SubjectModel *subjectModel = [[SubjectModel alloc] init];
    	[subjectModel setValuesForKeysWithDictionary:dic];
    	return subjectModel;
	}
	
	- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
		NSLog(@"UndefinedKey:%@", key);
	}
	@end	
	``` 

#### 注意点
1. UITableViewController中的view实质是定义的tableView然后赋值给UIViewController的view属性。两者指向同一个地址只是类型不一样而已。
2. UITableViewCell属性backgroundView会填充整个cell，而且cell的backgroundView属性优先级高于cell的backgroundColor属性。cell的contentView属性在内部其backgroundColor属性优先级又高于cell的backgroundView。多使用Debug->View Debugging->Capture View Hierarchy查看视图层次结构。
3. 如创建style为Plain的UITableView则对应的header往上滚动时当滚动到顶部时会保留在顶部而不再继续往上滚动，直到下一个header替代它；而style为Grouped时则会一直滚到。
4. UITableViewCell分割线默认有一个间距，可通过设置`cell.separatorInset = UIEdgeInsetsZero;`简单消除间距；也可以先设置`tableView.separatorStyle = UITableViewCellSeparatorStyleNone;`不显示分割线再自定义一个分割线视图。
5. 使用Masonry时mas_makeConstraints每次都是新增不会删除以前的容易造成重复添加多条相同的约束，mas_remakeConstraints每次都是先删除之前所有约束再添加新的。
6. 如果自定义cell需要依据内容调整计算高度，可以将cell高度值保存到模型中，不过在cell中赋值cell高度前需要[self layoutIfNeeded]强制刷新一下布局，否则计算高度有可能是以前值。从数据模型中获取cell高度最好对tableview设置一个预估常量高度值tableView.estimatedRowHeight(等同于实现estimatedHeightForRowAtIndexPath返回一个常量)，避免多次调用heightForRowAtIndexPath从模型中获取而达到一定程度上的优化。
7. 对于UILabel若要自动换行设置其numberOfLines为0，若想要文字高度计算正确，必须给每一行文字设置最大宽度preferredMaxLayoutWidth。	
8. 调用layoutIfNeeded如果有需要刷新的标记，立即调用layoutSubviews进行重新布局。如果没有标记不会调用layoutSubviews。注意结合约束和动画的使用不要忘记使用，否则可能达不到立即更新的预期效果。
9. 对属性和方法进行注释时采用/** 注释说明 */格式将其放在属性或方法上面，以后再别的地方使用时会显示对应的注释说明，方便了解属性或方法含义。
10. UITableView表视图滑动右侧删除按钮在iOS8之后是添加在UITableViewCell中(UITableViewCellDeleteConfirmationView)，不过在iOS11之后则添加在UITableView中(UISwipeActionPullView)。若想修改默认删除按钮样式在iOS8之后需自定义UITableViewCell重写layoutSubviews，在iOS11之后需自定义UITableView然后重写layoutSubviews。监听视图布局变化然后遍历所有子视图(通常最后一个就是删除视图可以先判断一下lastObject)使用isKindOfClass找到对应删除视图再进行样式布局更改。不过这种方式每次都要遍历不太好，后期寻找更好的解决方法。
11. 自定义不等高cell，添加新数据到最后并希望滚动到底部，需要在estimatedHeightForRowAtIndexPath中调用cellForRowAtIndexPath(真实目的是为了计算cell的高度，不同计算cell方式调用不同方法)创建和计算cell高度并返回真实高度用于计算整个tableview的高度使其知道滚动位置。
	


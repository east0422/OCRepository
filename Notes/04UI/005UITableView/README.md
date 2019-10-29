# UITableView
	继承于UIScrollView，默认垂直滚动，性能极佳。
    
#### 常用使用步骤
1. 设置数据源和代理，实现数据源和代理协议方法(可提前注册cell)。
2. 自定义cell(纯代码)。
	1. 重写initWithFrame:(最好也重写initWithStyle:reuseIdentifier:外面注册后调用dequeueReusableCellWithIdentifier会调用initWithStyle)。
	2. 重写layoutSubviews进行子视图布局。
	3. 重写模型，设置cell子视图控件显示值。
3. 取出cell进行数据赋值。

#### 注意点
1. 先注册可以使得用dequeueReusableCellWithIdentifier: 都会返回一个非nil的cell
	
	```
	// 提前注册一个table cell类，通常在viewDidLoad中
	// 纯代码创建cell在vc中注册然后使用dequeueReusableCellWithIdentifier获取会调用initWithStyle: reuseIdentifier:方法而不是使用initWithFrame:。如果未注册使用dequeueReusableCellWithIdentifier则会调用initWithFrame:。
	[tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"identifier"];
	// 如果是xib则需要使用registerNib
	// UINib *nib = [UINib nibWithNibName:@"xibname" bundle:[NSBundle mainBundle]];
	// [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"identifier"];
	
	// 后面使用，通常在数据源代理方法tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath中使用显示cell内容
	// 如果缓存池中有相同identifier的cell则取出来，如果没有的话就使用前面注册的创建一个新的。
	[tableView dequeueReusableCellWithIdentifier:@"identifier"];
	```
2. UITableViewController中的view实质是定义的tableView然后赋值给UIViewController的view属性。两者指向同一个地址只是类型不一样而已。
3. UITableViewCell属性backgroundView会填充整个cell，而且cell的backgroundView属性优先级高于cell的backgroundColor属性。cell的contentView属性在内部其backgroundColor属性优先级又高于cell的backgroundView。多使用Debug->View Debugging->Capture View Hierarchy查看视图层次结构。
4. 如创建style为Plain的UITableView则对应的header往上滚动时当滚动到顶部时会保留在顶部而不再继续往上滚动，直到下一个header替代它；而style为Grouped时则会一直滚到。
5. UITableViewCell分割线默认有一个间距，可通过设置`cell.separatorInset = UIEdgeInsetsZero;`简单消除间距；也可以先设置`tableView.separatorStyle = UITableViewCellSeparatorStyleNone;`不显示分割线再自定义一个分割线视图。
6. 使用setValuesForKeysWithDictionary:给数据模型赋值注意点：
		
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


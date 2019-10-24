# AutoLayout
	是一种“自动布局”技术，专门用来布局UI界面。在iOS6中引入但由于Xcode4不给力没有得到大规模推广。iOS7(Xcode5)开始Autolayout开发效率得到很大的提升，官方也推荐尽量使用Autolayout来布局ui界面。使用Autolayout需要关闭系统给我们添加的通过Autoresizing转成的约束即将对应视图的translatesAutoresizingMaskIntoConstraints设置为NO，默认为YES。
    
#### 核心
1. 参照
2. 约束
3. 警告和错误
	 1. 警告：控件的frame不匹配所添加的约束，比如约束控件的宽度为100，而控件现在的宽度是110。
   2. 错误：
      * 缺乏必要的约束，比如只约束了宽度和高度，没有约束具体的位置。
      * 两个约束冲突，比如1个约束控件的宽度为100，1个约束控件的宽度为110。

#### 添加约束规则
	在创建约束之后，需要将其添加到作用的view上，在添加时要注意目标view需要遵循以下规则：
1. 对于两个同层级view(兄弟view)之间的约束关系，添加到它们的父view上。
2. 对于两个不同层级view之间的约束关系，添加到它们最近的共同父view上。
3. 对于有层次关系的两个view之间的约束关系，添加到层级较高的父view上。总之对于两个view之间的约束关系添加到它们最近的一个共同祖先view上。

#### 代码实现
1. 利用NSLayoutConstraint类创建具体的约束对象

	```
	+ (id)constraintWithItem:(id)view1 // 要约束的控件
		attribute (NSLayoutAttribute)attr1 // 约束的类型(做怎样的约束)
		relatedBy:(NSLayoutRelation)relation // 与参照控件之间的关系
		toItem:(id)view2 // 参照的控件
		attribute:(NSLayoutAttribute)attr2 // 约束的类型
		multiplier:(CGFloat)multiplier // 乘数
		constant:(CGFloat)c; // 常量
	```
2. 添加约束对象到相应的view上 
	```
	 - (void)addConstraint:(NSLayoutConstraint *)constraint;
	 - (void)addConstraints:(NSArray *)constraints;
	```
3. 注意点：
	1. 要先禁止autoresizing功能，设置view下面属性为NO； view.translatesAutoresizingMaskIntoConstraints = NO;
	2. 添加约束前，一定要保证相关控件都已经在各自的父控件上。
	3. 不用再给view设置frame。

#### VFL
1. 定义：VFL全称是Visual Format Language，可视化格式语言，是苹果公司为了简化Autolayout的编码而推出的抽象语言。
2. 示例：
    * H:[cancelButton[72]]-12-[acceptButton[50]] cancelButton宽72、acceptButton宽50、它们之间间距12。
    * H:[wideView[>=60@700]] wideView宽度大于等于60point、该约束条件优先级为700(优先级最大值为1000、优先级越高的约束越先被满足)。
    * V:[redBox][yellowBox(==redBox)] 竖直方向上先有一个redBox、其下方紧接一个高度等于redBox高度的yellowBox。
    * H:I-10-[Find]-[FindNext]-[FindField[>=20]]-I水平方向上、Find距离父view左边缘默认间隔宽度、之后FindNext距离Find间隔默认宽度、再之后是宽度不小于20的FindField、它和FindNext以及父view右边缘的间距都是默认宽度。(竖线“|”表示superview的边缘)。
3. 使用VFL来创建约束数组
 
	```
	+ (NSArray *)constraintsWithVisualFormat:(NSString *)format // format为VFL语句
		options:(NSLayoutFormatOptions)opts // opts约束类型
		metrics:(NSDictionary *)metrics // metrics为VFL语句中用到的具体数值
		views:(NSDictionary *)views; // views为VFL语句中用到的控件
	```

#### 基于Autolayout的动画：
1. 在修改了约束之后，只要执行下面代码，就能做动画效果
  
	```
	[UIView animateWithDuration:1.0 animations:^{
		// 强制刷新
		[添加了约束的view父视图 layoutIfNeeded];
	}];
	```
	
#### 注意点
1. 使用storyboard/xib添加约束时如果选中Constrain to margins，则会依照layoutMargins的位置作为起点来进行约束会产生内边距，去掉选项的勾可以避免view产生内边距。
2. 使用storyboard/xib添加约束时注意Safe Area与Superview选择的区别。
3. UILabel设置lines为0会自动换行，可结合设置宽度约束小于等于某个值，这样当字符内容比较少时会自动缩短，而当字符内容比较多时依据设置最大宽度而自动换行。
4. 约束也可以拖线操作。
5. 使用代码添加约束前需先将视图添加进父视图中，否则位置不知道相对那个视图。宽高约束添加到自身视图上，相对位置约束添加到共同父视图上。



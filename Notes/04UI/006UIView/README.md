# UIView
	继承于UIResponder，能够对事件作出响应。
    
#### intrinsicContentSize
1. 固有内容大小，UILabel(会依据内容、字体、行数、换行模式等计算出它的大小)和UIButton等不需要设置大小有默认大小就是因为有该属性值。若想UILabel的大小总是比内容宽高都大一些(即所谓的留白)可以创建一个子UILabel然后重写该方法

	```
	// 注意UILabel对齐方式
	- (CGSize)intrinsicContentSize {
		CGSize originalSize = [super intrinsicContentSize];
		CGSize newSize = CGSizeMake(originalSize.width + 20, originalSize.height + 20);
		return newSize;
	}
	```
2. 若想给UIView一个默认大小需要自定义一个子UIView然后重写intrinsicContentSize方法返回默认大小，这样设置好该视图坐标位置后该视图大小和位置就都有了。
3. xib中先设置视图坐标然后在size inspector中将intrinsic Size设置为Placeholder，下面即可设置默认宽高。
	
#### contentHuggingPriority和contentCompressionResistance
1. 每个控件都有一个系统计算的最佳大小。
2. contentHuggingPriority属性代表控件拒绝本身size大于intrinsicSize的优先级。通俗理解就是该属性拉伸优先级，在垂直或水平方向上，若有多个视图控件，该优先级数值高的优先拉伸(优先级低的先不拉伸，先满足优先级低的约束)，xib中默认值为251，代码创建默认值为250。常和小于或等于约束一起使用。
3. contentCompressionResistance属性代表控件拒绝本身size小于intrinsicSize的优先级。简单理解该属性是指压缩优先级，同样在一个方向上，谁的优先级数值高就谁先压缩(先满足优先级数值低的约束)，xib和代码中默认值都是750。常和大于等于约束一起使用。
4. 如果是代码自动布局，自定义UIView常写在init方法中。自定义UIViewController常写在-(void)viewDidLoad()中。


#### setNeedsLayout
1. 标记为需要重新布局，异步调用layoutIfNeeded()刷新布局，不立即刷新，但是layoutSubViews()一定会被调用。

#### layoutIfNeeded
1. 如果有需要刷新的标记，立即调用layoutSubviews()进行布局；如果没有标记不会调用layoutSubviews()。
2. 在视图第一次显示之前，标记总是"需要刷新"的，可以直接调用[view layoutIfNeeded];
3. 若要立即刷新，要先调用setNeedsLayout()把标记设为需要布局然后马上再调用layoutIfNeeded()实现布局的立即刷新。

#### needsUpdateConstraints
1. 这个方法返回一个Bool值来决定view是否会执行updateConstraints()方法。

#### updateConstraints
1. 该方法一般会重写，用来更新特定的constraint。
2. 不要将该方法用于视图的初始化设置。
3. 当你需要在单个布局流程中添加、修改或删除大量约束时，用它来获得最佳性能。如果没有性能问题，直接更新约束更简单。

#### setNeedsUpdateConstraints
1. 和setNeedsLayout()方法类似，不过setNeedsLayout针对 Autolayout自动布局更新，前者针对frame布局更新。
2. 该方法会在每次view中布局发生变化时都会触发，提醒view应当更新了。相当于是设置一个标记，这个方法调用的时候布局变化并不会立刻生效，只是提醒系统。

#### updateConstraintsIfNeeded
1. 和layoutIfNeeded()类似，后者是针对Autolayout布局更新，前者是针对frame布局更新。
2. 该方法调用时会立刻强制刷新被标记为需要刷新的布局。



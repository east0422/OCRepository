# UI控件


#### 点(pt)与像素(px)
1. 点：点(points)是一个与分辨率无关的计算单位。根据屏幕的像素密度，一个点可以包含多个像素(eg，在标准Retina显示屏上1pt里有2 x 2个像素)。
2. 像素：像素(pixels)是数码显示上最小的计算单位。在同一个屏幕尺寸，更高的PPI(每英寸的像素数目)，就能显示更多的像素，同时渲染的内容也会更清晰。
3. 当为多种显示设备设计时，你应该以“点”为单位作参考，但设计还是以像素为单位设计的。这意味着仍然需要以3种不同的分辨率导出你的素材，不管你以哪种分辨率设计你的应用。

#### UIWindow
1. 是一种特殊的UIView，也是UIView的子类，通常在一个app中只会有一个UIWindow。
2. iOS程序启动完毕后，创建的第一个视图控件就是UIWindow，接着创建控制器的view，最后将控制器的view添加到UIWindow上，于是控制器的view就显示在屏幕上了。
3. 添加UIView到UIWindow的两种常见方式：
	* -(void)addSubview:(UIView*)view;直接将view添加到UIWindow中，但不理会view对应的UIViewController。
	* @property (nonatomic, retain) UIViewController *rootViewController;自动将rootViewController的view添加到UIWindow中，负责管rootViewController的生命周期。
4. 常用方法：
  *  -(void)makeKeyWindow;让当前UIWindow变成keyWindow(主窗口)。
  *  -(void)makeKeyAndVisible;让当前UIWindow变成keyWindow并显示出来。
5. 获取某个UIView所在的UIWindow: view.window。
6. 注意: 3.第一种方式是不能让控制器的view进行旋转，3.第二种方式控制器的view可以旋转，因为旋转事件传递是由UIApplication->UIWindow(窗口不做旋转处理，只有控制器才会做旋转处理)->UIViewController控制器的。
7. 作用：
	* 作为容器，包含app所要显示的所有视图。
	* 传递触摸消息到程序中view和其它对象。
	* 与UIViewController协同工作，方便完成设备方向旋转的支持。

#### 状态栏设置样式
1. 由控制器方法 -(UIStatusBarStyle)preferredStatusBarStyle决定。
2. 使用application设置application.statusBarStyle = UIStatusBarStyleLightContent;
3. 注意：2第二种方式默认不起作用，因为状态栏样式默认由控制器来管理，如果想用application设置状态栏则需在Info.plist中设置View controller-based status bar appearance = NO）。

#### 导航栏
1. 局部配置： 获取导航控制器的navigationBar属性self.navigationBar。
2. 全局配置：通过[UINavigationBar appearance]获取的导航条对象可以设置应用的”所有导航条”的样式。

#### 更改NavItem样式
1. 获取NavItem: UIBarButtonItem *navItem = [UIBarButtonItem appearance];
2. 更改样式
  * 改变整个按钮背景 [navItem setBackButtonBackgroundImage: [UIImage  imageNamed:@“NavBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault]; 
  * 设置Item的字体大小
 [navItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}forState:UIControlStateNormal];

#### UIView与CALayer
1. UIView属于UIKit负责渲染矩形区域的内容，为矩形区域添加动画，响应区域的触摸事件(继承UIResponder)，布局和管理一个或多个子视图。
2. CALayer属于QuartzCore，是用来绘制内容的，对内容进行动画处理，依赖于UIView来进行显示，不能处理用户事件。
3. 两者最大的区别是，图层不会直接渲染到屏幕上，UIView是iOS系统中界面元素的基础，所有的界面元素都是继承自它。它本身完全是由CoreAnimation来实现的，它真正的绘图部分，是由一个CALayer类来管理。
4. UIView和CALayer是相互依赖的，UIView依赖CALayer提供内容，CALayer依赖UIView的容器显示绘制内容。UIView本身更像一个CALayer的管理器，一个UIView上可以有n个CALayer，每个layer显示一种东西，增强UIView的展现能力。

#### frame与bounds
1. frame指的是该view在父view坐标系统中的位置和大小(参照点是父视图的坐标系统)。
2. bounds指的是该view在本身系统中的位置和大小(参照点是本身的坐标系统)。设置当前视图左上角相对子视图新的坐标值，默认为(0,0)，若设为(50,0)则子视图在视觉上向左偏移50，即以前的原点 (0,0)变为了(50,0)。

#### 视图UIView的创建
1. 创建流程：控制器view加载顺序从高到低依次为loadView() > storyboard > nibName.xib > View.xib > ViewController.xib > 空白view。
2. 用系统的loadView方法创建控制器的视图。
3. 若指定加载某个storyboard文件做控制器的视图，就会加载storyboard里面的描述去创建view。
4. 若指定读取某个xib文件做控制器的视图，就根据指定的xib文件去加载创建。
5. 若有xib文件名和控制器的类名前缀(也就是去掉controller)的名字一样的xib文件，就会用这个xib文件来创建控制器的视图(eg,控制器名为AAViewController xib文件名为AAView.xib)。
6. 找和控制器同名的xib文件去创建。
7. 如果以上都没有就创建一个空的控制器的视图。
8. 当你alloc并init了一个ViewController时，这个ViewController应该是还没有创建view的。ViewController的view是使用了lazyInit方式创建，就是说你调用的view属性的getter方法self.view。在getter里会先判断view是否创建，如果没有创建，那么会调用loadView来创建view。loadView完成时会继续调用viewDidLoad。loadView和viewDidLoad的一个区别就是loadView时还没有view，而viewDidLoad时view已经创建好了。

#### UIScrollView
1. 不能滚动常见原因：
	* 没有设置contentSize(滚动范围)
	* 禁用滚动scrollEnabled = NO或禁用了用户交互userInteractionEnabled = NO
	* 没有取消autolayout功能(要想scrollView滚动，必须取消autolayout)
2. 通常情况下可以在viewDidLoad中设置contentSize，但是在autolayout下，系统会在viewDidAppear之前根据subview的constraint重新计算scrollview的contentsize，所以前面手动设置的值会被覆盖掉也就是所谓的contentsize设置无效。解决方法有
	* 去除autolayout选项，自己手动设置contentsize。
	* 若要使用autolayout，要么自己设置完subview的constraint，然后让系统自动根据constraint计算出contentsize。要么延迟在viewDidAppear里面自己手动设置contentsize。

#### UIButton
1. UIButton的imageView属性是只读属性不能赋值，故不能通过该属性更改图片。
2. `btn.titleLabel.text = @"title"`不显示title，使用`[btn setTitle:title forState:UIControlStateNormal];`。
3. 默认image在左，title在右，若想重新排列image和title布局样式，只需自定义一个CusUIButton继承UIButton，然后实现titleRectForContentRect和imageRectForContentRect在其中重新布局即可。

#### UIImage两种加载方式(内存优化)
1. `+ (UIImage *) imageNamed:(NSString *)name;` // name是图片文件名
	* 加载到内存以后，会一直停留在内存中，不会随着对象销毁而销毁，有缓存。
	* 加载图片到内存以后，占用的内存归系统管理，程序员无法管理。
	* 相同的图片不会重复加载，重复加载同一张图片占据内存不会增大。
	* 加载到内存当中后，占据内存空间较大。
2. `类方法+ (UIImage *)imageWithContentsOfFile:(NSString *)path 对象方法- (id)initWithContentsOfFile:(NSString *)path // path是图片全路径`
	* 加载到内存当中后，占据内存空间较小，无缓存。
	* 相同的图片会被重复加载到内存当中，重复加载同一张图片占据内存会不断增大。
	* 对象销毁的时候，加载到内存中的图片会随着一起销毁，图片所占用的内存会（在一些特定操作后）被清除。
3. 放在xcassets里面的图片只能通过imageNamed方法加载，图片放在非cassettes中则可以通过[[NSBundle mainBundle] pathForResource: imageName ofType: imageType];获取对应图片路径后再使用上述2加载图片。
4. 可将多张图片放入一个数组赋值给UIImageView的animationImages属性然后调用startAnimating开始动画播放，不过需要注意的是在动画播放完成后记得将animationImages置为nil避免长期占用内存资源[self.imageView performSelector:@selector(setAnimationImages:) withObject:nil after:self.imageView.animationDuration+0.1]。

#### UIImageView添加圆角
1. 最直接的方法就是使用属性设置`imageView.layer.cornerRadius = 10; imageView.masksToBounds = YES;`，该方法好处是使用简单，操作方便。但坏处是离屏渲染(off-screen-rendering)需要消耗性能。对于图片较多的视图不建议使用这种方法来设置圆角。在iOS9之后系统做了优化不会产生离屏渲染。
	* 通常来说，计算机系统中CPU、GPU、显示器是协同工作的。CPU计算好显示内容提交到GPU，GPU渲染完成后将渲染结果放入帧缓冲区。
	* 离屏渲染导致本该CPU干的活交给了CPU来干，而CPU又不擅长GPU干的活，于是拖慢了UI层的数据帧率(FPS)，并且离屏需要创建新的缓冲区和上下文切换，因此消耗较大的性能。
2. 给UIImage添加生成圆角图片的扩展API，然后调用时就直接传一个圆角来处理`imageView.image = [[UIImage imageNamed:@"test"] east_imageWithCornerRadius:10];`，这么做就是在屏渲染了(on-screen-rendering)。通过模拟器->debug->Color Off-screen-rendering看到没有离屏渲染了(黄色的小圆角没有显示了说明这个不是离屏渲染了)。

	```
	- (UIImage *)east_imageWithCornerRadius:(CGFloat)radius inBounds:(CGRect)bounds {
		UIGraphicsBeginImageContextWithOptions(bounds.size, NO, UIScreen.mainScreen.scale);
		CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radius].CGPath);
		CGContextClip(UIGraphicsGetCurrentContext());
		[self drawInRect:bounds];
		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return image;
	}
	```
3. 通过mask遮罩实现，性能消耗比设置属性的消耗更大。

	```
	CAShapeLayer *layer = [CAShapeLayer layer];
  	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:self.imageView.bounds];
  	layer.path = bezierPath.CGPath;
   self.imageView.layer.mask = layer;
	```

#### storyboard
1. IBAction
	* 从返回值角度上看，作用相当于void。
	* 只有返回值声明为IBAction的方法，才能跟storyboard中的控件进行连线。
2. IBOutlet
	* 只有声明为IBOutlet的属性，才能跟storyboard中的控件进行连线。

#### layoutSubViews和drawRects
1. layoutSubViews在以下情况下会被调用(视图位置变化是触发)：
	* init初始化不会触发layoutSubviews。
	* addSubview会触发layoutSubviews。
	* 设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化。
	* 滚动一个UIScrollView会触发layoutSubviews。
	* 旋转Screen会触发父UIView上的layoutSubviews事件。
	* 改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件。
	* 直接调用setLayoutSubviews。
2. drawRect在以下情况下会被调用：
	* 如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。drawRect调用是在Controller->loadView，Controller->viewDidLoad两方法之后调用的，所以不用担心在控制器中这些View的drawRect就开始画了，这样可以在控制器中设置一些值给View（如果这些View draw的时候需要用到某些变量值）。
	* 该方法在调用sizeToFit后被调用，所以可以先调用sizeToFit计算出size，然后系统自动调用drawRect:方法。
	* 通过设置contentMode属性值为UIViewContentModeRedraw，那么将在每次设置或更改frame的时候自动调用drawRect：。
	* 直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect：，但是有个前提条件是rect不能为0。
3. 使用drawRect注意点：
	* 若使用UIView绘图，只能在drawRect：方法中获取相应的contextRef并绘图。如果在其他方法中获取将获取到一个invalidate的ref并且不能用于画图。drawRect:方法不能手动显示调用，必须通过调用setNeedsDisplay或者setNeedsDisplayInRect，让系统自动调用该方法。
	* 若使用CAlayer绘图，只能在drawInContext：中绘制，或者在delegate中的相应方法绘制。同样也是调用setNeedDisplay等间接调用以上方法。
	* 若要实时画图，不能使用gestureRecognizer，只能使用touchBegan等方法来调用setNeedsDisplay实时刷新屏幕。


#### UIViewController
1. 每当显示一个新界面时，首先会创建一个新的UIViewController对象，然后创建一个对应的全局UIView，UIViewController负责管理这个UIView。
2. UIViewController就是UIView的大管家，负责创建、显示、销毁UIView，负责监听   UIView内部的事件，负责处理UIView与用户的交互。
3. UIViewController内部有个UIView属性，它负责管理UIView对象:  @property(nonatomic, retain) UIView *view。
 
####  视图控制器的生命周期
1. loadView，尽管不直接调用该方法(eg，多手动创建自己的视图)，那么应该覆盖这个方法并将它们赋值给视图控制器的view属性。viewController会在view的property被请求并且当前view值为nil时调用这个函数。若手动创建view，应该重载这个函数且不要在重载时调用[super loadView]。
2. viewDidLoad，只有在视图控制器将其视图载入到内存之后才调用该方法，这是执行任何其他初始化操作的入口。这个函数的作用主要是让你可以进一步的初始化你的views，通常负责的是view及其子view被加载进内存之后的数据初始化的工作，即视图的数据部分的初始化。
3. viewWillAppear，当视图将要添加到窗口中并且还不可见的时候或者上层视图移出图层后本视图变成顶级视图时调用该方法，用于执行诸如改变视图方向等的操作。实现该方法时确保调用[super viewWillAppear:]。
4. viewDidAppear，当视图添加到窗口中以后或上层视图移出图层后本视图变成顶级视图时调用，用于放置那些需要在视图显示后执行的代码。确保调用[super viewDidAppear:]。
5. viewWillDisappear，控制器对象的视图即将消失，被覆盖或隐藏时调用。
6. viewDidDisappear，控制器对象的视图已经消失、被覆盖或隐藏时调用。

#### 视图控制器UIViewController的创建方式
1. UIStoryboard
 	1. 获取storyboard：UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];。
 	2. 依据storyboard创建视图控制器：
		* [storyboard instantiateInitialViewController]获取箭头所指的视图控制器。
    	* [storyboard instantiateViewControllerWithIdentifier:ID]获取标识ID所指视图控制器。
2. xib： [[ViewControllerName alloc] initWithNibName:name bundle:nil]。
3. 代码：[[ViewControllerName alloc] init]。

#### ViewController良好设计
1. init里不要出现创建view的代码，在init里应该只有相关数据的初始化，而且这些数据都是比较关键的数据。init里不要调用self.view否则会导致viewController创建view(view是lazyinit的)。
2. loadView中只初始化view，一般用于创建比较关键的view如tableViewController的tableView，UINavigationController的navigationBar，不可调用view的getter(在调用super loadView前)，最好也不要初始化一些非关键的view。如果你是从nib文件中创建的viewController在这里一定要先调用super的loadView方法，但建议不要重载这个方法。
3. viewDidLoad这时候view已经有了，最适合创建一些附加的view和控件了。
4. viewWillAppear这个一般在view被添加到superview之前，切换动画之前调用。在这里可以进行一些显示前的处理，比如键盘弹出，一些特殊的过程动画(如状态条和navigationbar颜色)。
5. viewDidAppear一般用于显示后，在切换动画后，如果有需要的操作可以在这里加入相关代码。
6. viewDidUnLoad这时候viewController的view已经是nil了。由于这一般发生在内存警告时，所以在这里你应该将哪些不再显示的view释放了。比如你在viewController的view上加了一个label，而且这个label是viewController的属性，那么你要把这个属性设置成nil，以免占用不必要的内存，而这个label在viewDidLoad时会重新创建。

#### presentViewController与pushViewController失效
1. self.presentViewController不起作用，显示的还是原始vc，将其放到异步线程中：

	```
	DispatchQueue.main.async {
	  self.present(vc, animated: true, completion: nil)
	}
	```
2. 将其放移到viewDidAppear中。






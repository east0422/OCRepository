# UIImageView
   
    
#### UIImage加载方式(内存优化)
1. `+ (UIImage *) imageNamed:(NSString *)name;` // name是图片文件名
	* 系统会先检查系统缓存中是否有该名字的image，如果有则直接返回，没有的话则先加载图像到缓存，然后再返回。 
	* 加载到内存以后，会一直停留在内存中，不会随着对象销毁而销毁，有缓存。
	* 加载图片到内存以后，占用的内存归系统管理，程序员无法管理。
	* 相同的图片不会重复加载，重复加载同一张图片占据内存不会增大。
	* 加载到内存当中后，占据内存空间较大。
2. `类方法+ (UIImage *)imageWithContentsOfFile:(NSString *)path 对象方法- (id)initWithContentsOfFile:(NSString *)path // path是图片全路径`
	* 系统不会检查缓存而直接从文件系统中加载并返回。
	* 加载到内存当中后，占据内存空间较小，无缓存。
	* 相同的图片会被重复加载到内存当中，重复加载同一张图片占据内存会不断增大。
	* 对象销毁的时候，加载到内存中的图片会随着一起销毁，图片所占用的内存会（在一些特定操作后）被清除。
3. `+ (UIImage *)imageWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;`
 	* 当scale=1时图像为原始大小，orientation指定绘制图像的方向。
 	* 不缓存图像对象，可使用Core Graphics framework创建图像引用。
4. 放在Assets里面的图片只能通过imageNamed方法加载，图片放在非Assetes中则可以通过[[NSBundle mainBundle] pathForResource: imageName ofType: imageType];获取对应图片路径后再使用上述2加载图片。
5. 可将多张图片放入一个数组赋值给UIImageView的animationImages属性然后调用startAnimating开始动画播放，不过需要注意的是在动画播放完成后记得将animationImages置为nil避免长期占用内存资源[self.imageView performSelector:@selector(setAnimationImages:) withObject:nil after:self.imageView.animationDuration+0.1]。

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



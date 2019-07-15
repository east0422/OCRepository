# Animation动画


#### Animation
1. 基本动画

	```
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	animation.toValue = [NSNumber numberWithFloat:-1.2];
	animation.duration = 4;
	[_demoView.layer addAnimation:animation forKey:nil];
	```
2. 关键帧动画
	
	```
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	// 如果你设置了path，那么values将被忽略
	UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 200, 200)];
	animation.path = path.CGPath;
	animation.duration = 4;
	[_demoView.layer addAnimation:animation forKey:@"pathAnimation"];
	```
3. 组合动画

	```
	CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
	groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
	groupAnimation.duration = 4.0f;
	```
4. 过渡动画

	```
	 CATransition *animation = [CATransition animation];
	// 设置动画的类型
	animation.type = kCATransitionFade;
	// 设置动画的方向
	animation.subtype = kCATransitionFromRight;
	// animation.startProgress = 0.3; // 设置动画起点
	// animation.endProgress = 0.8; // 设置动画终点
	animation.duration = 0.8;
	[self.demoView.layer addAnimation:animation forKey:AnimationType];
	```
5. 仿射变换

	```
	self.demoView.transform = CGAffineTransformIdentity;
	[UIView animateWithDuration:1 animations:^{
	    self.demoView.transform = CGAffineTransformMakeTranslation(100, 100);
	}];
	```

#### 第三方动画库
1. DCPathButton：动画子按钮，点击按钮弹出更多按钮。
2. DWBubbleMenuButton：冒泡子按钮。
3. MCFireworksButton：粒子点赞按钮。


# UIScrollView
    
    
#### 常用说明
1. 不能滚动常见原因：
	* 没有设置contentSize(滚动范围)
	* 禁用滚动scrollEnabled = NO或禁用了用户交互userInteractionEnabled = NO
	* 没有取消autolayout功能(要想scrollView滚动，必须取消autolayout)
2. 通常情况下可以在viewDidLoad中设置contentSize，但是在autolayout下，系统会在viewDidAppear之前根据subview的constraint重新计算scrollview的contentsize，所以前面手动设置的值会被覆盖掉也就是所谓的contentsize设置无效。解决方法有
	* 去除autolayout选项，自己手动设置contentsize。
	* 若要使用autolayout，要么自己设置完subview的constraint，然后让系统自动根据constraint计算出contentsize。要么延迟在viewDidAppear里面自己手动设置contentsize。
3. 获取子控件视图时需要注意若显示滚动条则两个UIImageView滚动条控件也在其子控件数组中，两个滚动条子控件通常在设置contentSize(对比旧值有更改)后会放在数组末尾，设置之前在数组中位置并不确定。


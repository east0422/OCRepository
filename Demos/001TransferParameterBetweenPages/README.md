#### OC页面A和B间传递参数(A与B是相对的）
1. A --> B: 实质是为B添加属性，在A跳转到B前对B属性进行赋值。
	* 属性/自定义init。
2. B --> A: 实质是为A添加方法，在B跳回A前调用对应的方法。
	* Block块
	* Delegate/Protocol（参数回传）。
	* 通知。
3. A <--> B: 实质是定义全局可变可访问的属性。
	* 自定义单例类。
	* sharedApplication。
	* 使用文件或NSUserdefault。


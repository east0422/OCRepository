# autoresizing
    在iOS2中引入用于屏幕适配，指定当父视图的bounds发生改变时如何自动调整子视图的布局。Autoresizing和Auto Layout不能共存，所以如果使用Autoresizing，就不能勾选Use Auto Layout。
    
#### 两个重要UIView属性
1. autoresizesSubviews：用于标识当自身的bounds发生改变时是否自动调整子视图的布局，默认为YES。当设置为YES时t，它的bounds发生改变时它会根据每个子视图的autoresizingMask属性设置值自动为其调整布局。
2. autoresizingMask：用于标识当父视图的bounds发生改变时如何自动调整自身的布局，默认为UIViewAutoresizingNone。

#### 通过storyboard/xib方式
1. Xcode中默认开启了Autolayout技术, 在使用Autoresizing技术前需要手动将其关闭，在File inspector中去掉勾选use Auto Layout。
2. 选中对应视图view的父视图在Attributes inspector中勾选Autoresize Subviews用于标识当父视图的bounds发生改变时自动调整子视图的布局；在对应视图view的Size inspector中可看见Autoresizing，依据需要将虚线设置为实线（位于外部的四根线分别用于标识如何自动调整与父视图的上/下/左/右边距，如果是实线代表不会自动调整即保持边距不变；位于内部的两根线分别用于标识如何自动调整自身的宽度和高度，如果是实线代表自动调整即自动适应伸缩）即设置autoresizingMask属性值。
3. Preview中可添加多个设备预览图。

#### 通过code方式
1. autoresizesSubviews默认为YES。
2. 设置autoresizingMask值。

#### 注意点
1. Autoresizing只能设置父子视图之间的关系，也就是说，Autoresizing只能控制子视图和父视图之间的位置/大小关系。Autoresizing不能设置兄弟视图之间的关系，当然也不能设置完全不相关的两个视图之间的关系。
2. UIView的autoresizesSubviews属性为YES时（默认为YES），autoresizingMask才会生效。也就是说，当我们想要利用autoresizingMask指定某个控件和其父控件的关系时，其父控件必须autoresizesSubviews = YES。

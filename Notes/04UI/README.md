# UI控件

## 1. 如何解决缓存池满的问题(cell)
* ios中不存在缓存池满的情况，因为通常在ios开发，对象都是在需要的时候才会创建(懒加载)，还有在UITableView中一般只会创建刚开始出现在屏幕中的cell，之后都是从缓存池中取，不会再创建新对象，缓存池里最多也就一两个对象。缓存池满的在java中比较常见，java中一般把最近最少使用的对象先释放。

## 2. CAAnimation
* CAMediaTiming为CAAnimation实现的协议。
* CAAnimationGroup为CAAnimation子类，组动画，常用于将多个动画组合在一起。
* CATransition为CAAnimation子类，转场动画，常用于转场渐变。
* CAPropertyAnimation为CAAnimation子类，属性动画，很少使用，通常使用其子类。
* CABasicAnimation为CAPropertyAnimation子类，基本属性动画，可看作只有头尾关键帧的动画。
* CAKeyframeAnimation为CAPropertyAnimation子类，关键帧动画，可用于设置不同帧动画效果。

## 3. CALayer与UIView的区别
* 两者最大的区别是，图层不会直接渲染到屏幕上，UIView是iOS系统中界面元素的基础，所有的界面元素都是继承自它。它本身完全是由CoreAnimation来实现的，它真正的绘图部分，是由一个CALayer类来管理。
* UIView本身更像一个CALayer的管理器，一个UIView上可以有n个CALayer，每个layer显示一种东西，增强UIView的展现能力。

## 4. frame与bounds
* frame指的是该view在父view坐标系统中的位置和大小(参照点是父视图的坐标系统)。
* bounds指的是该view在本身系统中的位置和大小(参照点是本身的坐标系统)。






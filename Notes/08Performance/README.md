# 性能优化

## 1. UITableview
* 正确使用reuseIdentifier来复用单元格。
* 尽量使用不透明的视图，单元格中尽量少使用动画。
* 图片加载使用异步加载，并且设置图片加载的并发数。
* 滑动时不加载图片，停止滑动开始加载。滚动很快时只加载目标范围内的cell, 按需加载极大的提高流畅度。
* 文字、图片可以直接drawInRect绘制。
* 减少reloadData全部cell，只reloadRowsAtIndexPaths。
* 提前计算出高度并缓存，因为heightForRowAtIndexPath:是调用最频繁的方法。cell高度固定的话直接用cell.rowHeight设置高度。
* 尽量少用addView给cell动态添加view，可以初始化时就添加然后通过hide来控制是否显示。
* 若cell显示内容来自web，使用异步加载并缓存请求结果。



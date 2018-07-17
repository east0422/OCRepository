# 性能优化

## 1. tableview的滑动速度
* 复用单元格。
* 使用不透明的视图，单元格中尽量少使用动画。
* 图片加载使用异步加载，并且设置图片加载的并发数。
* 滑动时不加载图片，停止滑动开始加载。
* 文字、图片可以直接drawInRect绘制。
* 减少reloadData全部cell，只reloadRowsAtIndexPaths。
* 若cell时动态行高，计算出高度后缓存。
* cell高度固定的话直接用cell.rowHeight设置高度。



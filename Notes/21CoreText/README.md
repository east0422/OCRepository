# CoreText


#### 简介
1. CoreText是用于处理文字和字体的底层技术，直接和Core Graphics(又称Quartz，是一个2D图形渲染引擎，能够处理OSX和iOS中的图形显示问题)打交道。上层的UI控件和WKWebview都是基于CoreText来实现的。
2. Quartz能够直接处理字体font和字形glyphs，将文字渲染到界面上，它是基础库中唯一能够处理字形的模块。因此，CoreText为了排版，需将显示的文本内容、位置、字体、字形直接传递给Quartz。与其他UI组件相比，由于CoreText直接和Quartz来交互，所以它具有高效的排版功能。

#### 图片和链接点击响应
1. 区域位置
	1. 图片数据模型添加一个CGRect类型position，链接文本模型则需要添加一个数组positions(可能是个长链接占据多行有多个区域，CGRect非对象类型存储时需转为NSValue，使用时再转换为CGRect)。
	2. 解析数据时对图片类型添加一个kCTRunDelegateAttributeName类型代理，对链接数据添加一个NSUnderlineStyleAttributeName下划线样式。
	3. 遍历每一个CTLineRef和CTRunRef获取CTRunRef的attributes属性字典，然后获取kCTRunDelegateAttributeName和kCTUnderlineStyleAttributeName判断是否为nil即可判定当前CTRunRef是图片还是链接，最后获取对应区域赋值给图片position或添加到链接positions中。
	4. 遍历图片和文本链接获取位置区域(如果获取时存放的是CoreText坐标则在这里需转换为UIKit坐标，遍历文本链接数组获取NSValue转换为CGRect)判断点击位置坐标是否在对应区域中即可响应相应处理。
2. 图片占位符索引和链接文本起始索引和长度
	1. 为图片数据模型添加索引index，为文本链接添加NSRange存储文本链接首字符索引和长度。
	2. 解析数据时为图片和文本链接计算赋值正确索引值和NSRange。
	3. 获取当前点击位置字符索引，遍历图片索引进行比较，遍历链接range查看是否在其中，若相等或在文本链接范围中则可进行相应处理。
	4. 注意CTLineGetStringIndexForPosition获取索引idx时会出现向左偏移一半(前一个右半边和当前左半边能响应，当前右半边不响应)，解决方法时在获取idx后调用CTLineGetOffsetForStringIndex(line, idx, NULL)获取返回值若返回值比relativePoint.x值大且idx大于0则idx--。



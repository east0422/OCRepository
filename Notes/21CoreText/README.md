# CoreText


#### 简介
1. CoreText是用于处理文字和字体的底层技术，直接和Core Graphics(又称Quartz，是一个2D图形渲染引擎，能够处理OSX和iOS中的图形显示问题)打交道。上层的UI控件和WKWebview都是基于CoreText来实现的。
2. Quartz能够直接处理字体font和字形glyphs，将文字渲染到界面上，它是基础库中唯一能够处理字形的模块。因此，CoreText为了排版，需将显示的文本内容、位置、字体、字形直接传递给Quartz。与其他UI组件相比，由于CoreText直接和Quartz来交互，所以它具有高效的排版功能。



# WebView与JS


#### 原生与JS交互
1. UIWebView
	1. iOS 2.0–12.0，推荐使用WKWebView代替。
	2. 主要使用JavaScriptCore框架，通过一个JSContext获取UIWebView的JS执行上下文，然后通过这个上下文进行OC与JS的双端交互。
2. WKWebView
	1. WKWebViewConfiguration
	2. WKUserContentController
3. WebViewJavascriptBridge
	1. 第三方开源框架，可用于WKWebView & UIWebView中OC和JS交互。
	2. 基本原理是将OC的方法注册到桥梁中让JS去调用，把JS方法注册到桥梁中让OC去调用。
4. React Native。
5. Cordova。
6. Weex。

#### 加载html图片及样式显示不正确解决方案
1. 将整个html文件夹拖入到工程中勾选Create folder references，加载html时指定其目录([[NSBundle mainBundle] URLForResource:@"html/index.html" withExtension:nil];)。
2. 勾选Create groups，加载html只指定html文件([[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];)，修改index.html中样式引用及图片资源文件路径不加目录(./images/101.jpg -> 101.jpg)。
3. 在2基础上不更改html内容，加载之后在原生代码中处理遍历<img src>替换src值。

#### WKWebView
1. 通过userContentController把需要观察的JS执行函数注册起来，然后通过一个协议方法将所有注册过的JS函数执行的参数传递到此协议方法中。
	
	```
	// 注册需要观察的JS执行函数, wkMessageHandler为遵循WKScriptMessageHandler协议类对象
	[wkWebView.configuration.userContentController addScriptMessageHandler:wkMessageHandler name:@"iOSCall1"];
	[wkWebView.configuration.userContentController addScriptMessageHandler:wkMessageHandler name:@"iOSCall2"];
	// WKMessageHandlerl类遵循WKScriptMessageHandler协议实现userContentController:didReceiveScriptMessage:方法
	- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
		// message.name判断那个iOSCall调用，message.body则是js传递过来的参数
	}
	
	// JS中调用函数并传递参数数据
	window.webkit.messageHandlers.iOSCall.postMessage(params);
	```

#### WebViewJavascriptBridge基本使用步骤
1. 导入WebViewJavascriptBridge

	```
	pod 'WebViewJavascriptBridge'
	```
2. 在oc中导入头文件WebViewJavascriptBridge.h建立WebViewJavascriptBridge与WebView之间的关联并往桥梁中注入OC方法。
	
	```
	// 建立webview与桥梁关联
	jsBridge = [WebViewJavascriptBridge bridgeForWebView: webView];
	// 注入OC方法。iOSCall1是OC block的一个别名，block是JS调用iOSCall1时执行的代码块，data是JS传过来的数据，responseCallback是OC block执行完毕后往JS回传的数据
	[jsBridge registerHandler:@"iOSCall1" handler:^(id data, WVJBResponseCallback responseCallback){
		responseCallback(@"处理结果");
	}];
	```
3. 在js中建立与WebViewJavascriptBridge的关联并往桥梁中注入JS方法
	
	```
	function setupWebViewJavascriptBridge(callback) {
        if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
        if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
        window.WVJBCallbacks = [callback]; // 创建一个 WVJBCallbacks 全局属性数组，并将 callback 插入到数组中。
        var WVJBIframe = document.createElement('iframe'); // 创建一个 iframe 元素
        WVJBIframe.style.display = 'none'; // 不显示
        WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__'; // 设置 iframe 的 src 属性
        document.documentElement.appendChild(WVJBIframe); // 把 iframe 添加到当前文导航上。
        setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}
// 注册JS方法。jsCall1是js函数，data是OC传过来的数据，responseCallback是JS调用完毕后传递给OC的数据
setupWebViewJavascriptBridge(function(bridge){ 
	bridge.registerHandler('jsCall1', function(data, responseCallback) {
		responseCallback({data:"js数据", from:"js"});
	}  
});
```
4. 相互调用
	
	```
	// JS调用OC
	// 不传参，无返回值
	WebViewJavascriptBridge.callHandler('iOSCall1');
	// 传参，无返回值
	WebViewJavascriptBridge.callHandler('iOSCall1", "传给OC参数");
	// 传参，有返回值
	WebViewJavascriptBridge.callHandler('iOSCall1', '传给OC参数', function(dataFromOC) {
		// dataFromOC是OC返回数据
	});
	
	// OC调用JS
	// 不传参，无返回值
	[jsBridge callHandler:@"jsCall"];
	// 传参，无返回值
	[jsBridge callHandler:@"jsCall" data:@"传递给JS参数"];
	// 传参，有返回值
	[jsBridge callHandler:@"jsCall: data:@"传递给JS参数", responseCallback:^(id responseData) {
		// responseData返回值
	}];
	```
	5. 在OC中往桥梁中注入block时，当前控制器消失时记得要把注入到桥梁中的OC block从桥梁中移除，否则可能出现控制器无法释放的情况。
	
	```
	- (void)viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
		[jsBridge removeHandler:@"iOSCall"];
	}
	```

#### UIWebView
1. 加载网页

	```
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
	```
2. 删除

	```
	NSString *str1 = @"var word = document.getElementById('word');";
	NSString *str2 = @"word.remove();";
	[webView stringByEvaluatingJavaScriptFromString:str1];
	[webView stringByEvaluatingJavaScriptFromString:str2];
	```
3. 更改

	```
	NSString *str3 = @"var change = document.getElementsByClassName('change')[0];"
	"change.innerHTML = '你好!';";
	[webView stringByEvaluatingJavaScriptFromString:str3];
	```
4. 插入
	
	```
	NSString *str4 = @"var img = document.createElement('img');"
		"img.src = 'img_01.jpg';"
		"img.width = '160';"
		"img.height = '80';"
		"document.body.appendChild(img);";
	[webView stringByEvaluatingJavaScriptFromString:str4];
	```
5. 改变标题

	```
	NSString *str5 = @"var h1 = document.getElementsByTagName('h1')[0];"
		"h1.innerHTML = '新的标题';";
	[webView stringByEvaluatingJavaScriptFromString:str5];
	```
6. 删除尾部

	```
	NSString *str6 = @"document.getElementById('footer').remove();";
	[webView stringByEvaluatingJavaScriptFromString:str6];
	```
7. 获取所有的网页内容

	```
	NSString *str7 = @"document.body.outerHTML";
	NSString *html = [webView stringByEvaluatingJavaScriptFromString:str7];
	```
	
#### 在HTML中调用OC
1. 实现WebView代理方法

	```
	-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *str = request.URL.absoluteString;
	NSRange range = [str rangeOfString @"ABC://"];
	if (range.location != NSNotFound) {
		NSString *method = [str substringFromIndex:range.location + range.length];
		SEL sel = NSSelectorFromString(method);
		[self performSelector:sel];
	}
	return YES;
}
	```
	
#### JavaScriptCore(JSCore)
1. JavaScriptCore是webkit的一个重要组成部分，主要是对JS进行解析和提供执行环境。iOS7后苹果在iPhone平台推出，极大的方便了对js的操作。可以脱离webview直接运行我们的js。ios7以前对js操作只有webview里面一个函数stringByEvaluatingJavaScriptFromString，JS对OC的回调都是基于URL的拦截进行的操作。大家用的比较多的是WebViewJavascriptBridge和EasyJSWebView这两个开源库，很多混合都采用这种方式。JavaScriptCore线程是安全的，每个context运行的时候通过lock关联的JSVirtualMachine。若要进行并发操作，可以创建多个JSVirtualMachine实例进行操作。
2. JSContext: JS执行的环境，同时也通过JSVirtualMachine管理着所有对象的生命周期，每个JSValue都和JSContext相关联并且强引用context。
3. JSValue: JS对象在JSVirtualMachine中的一个强引用，其实就是Hybird对象。我们对JS的操作都是通过它。并且每个JSValue都是强引用一个context，同时，OC和JS对象之间的转换也是通过它，相应的类型转换如下：
	
	```
	nil <-> undefined; NSNull <-> null; NSString <-> string; NSNumber <-> number, boolean; NSDictionary <-> Object object; NSArray <-> Array object; NSDate <-> Date object; NSBlock(1) <-> Function object(1); id(2) <-> Wrapper object(2); Class(3) <-> Constructor object(3);
	```
4. JSManagedValue: JS和OC对象的内存管理辅助对象。由于JS内存管理是垃圾回收，并且JS中的对象都是强引用，而OC是引用计数。如果双方相互引用，势必会造成循环引用而导致内存泄漏。我们可以用JSManagedValue保存JSValue来避免。
5. JSVirtualMachine: JS运行的虚拟机，有独立的堆空间和垃圾回收机制。
6. JSExport: 一个协议，如果JS对象想直接调用OC对象里面的方法和属性，那么这个OC对象只要实现这个JSExport协议就可以了。
7. OC调用JavaScript方法

	```
	self.context = [[JSContext alloc] init];
	NSString *jsstr = @"function add(a, b) {return a+b}";
	[self.context evaluateScript:jsstr];
	JSValue *sum = [self.context[@"add"] callWithArguments:@[@2, @3]];
	NSLog(@"sum is %@", @([sum toInt32])); // sum is 5
	```
8. JavaScript调用OC方法
	* block: 定义一个block，然后保存到context里面，其实就是转换成了JS的function。然后直接执行这个function，调用的就是block里面的内容了。
	
		```
		self.context = [[JSContext alloc] init];
		self.context[@"add"] = ^(NSInteger a, NSInteger b) {
			NSLog(@"sum is %@", @(a+b));
		};
		[self.context evaluateScript:@"add(2,3)"];
		```
	* JSExport protocol: 在JS中调用这个对象的方法，并将结果赋值给sum。需要注意的是OC的函数命名和JS函数命名规则问题，协议中定义的是add:b:，但是JS里面方法名字是addB(a,b)。可以通过JSExportAs这个宏转换成JS的函数名字。
	
		```
		// 定义一个JSExport protocol
		@protocol JSExportTest <JSExport>
		
		- (NSInteger)add:(NSInteger)a b:(NSInteger)b;
		@property (nonatomic, assign) NSInteger sum;
		
		@end
		
		// 创建一个对象去实现这个协议
		@interface JSProtocolObj: NSObject<JSExportTest>
		@end
		
		@implementation JSProtocolObj
		@synthesize sum = _sum;
		
		// 实现协议add:b:方法
		- (NSInteger)add:(NSInteger)a b:(NSInteger)b {
			return a + b;
		}
		// 重写setter方法方便调试打印信息
		- (void)setSum:(NSInteger)sum {
			NSLog(@"sum is %@", @(sum));
			_sum = sum;
		}
		
		@end
		
		// VC中进行测试
		@interface ViewController () <JSExportTest>
		
		@property (nonatomic, strong) JSProtocolObj *obj;
		@property (nonatomic, strong) JSContext *context;
		
		@end
		
		@implementation ViewController
		
		- (void)viewDidLoad {
			[super viewDidLoad];
			// 创建context
			self.context = [[JSContext alloc] init];
			// 设置异常处理
			self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
				[JSContext currentContext].exception = exception;
				NSLog(@"exception:%@", exception);
			};
			// 将obj添加到context中
			self.context[@"OCOBJ"] = self.obj;
			// JS里面调用obj方法，并将结果赋值给obj的sum属性
			[self.context evaluateScript:@"OCOBJC.sum = OCOBJC.addB(2,3)"];
		}
		```
9. 内存管理：OC使用ARC，JS使用的是垃圾回收机制，并且所有的引用都是强引用，不过JS的循环引用，垃圾回收会帮它们打破。JavaScriptCore里面提供的API，正常情况下，OC和JS对象之间内存管理都无需我们去关心，不过有几个注意点需留意下
	* 不要在block里面直接使用context或者使用外部的JSValue对象。
	
		```
		// 明显的错误代码
		self.context[@"block"] = ^() {
			// block中使用self，编译器会有提示
			JSValue *value = [JSValue valueWithObject:@"aaa" inContext:self.context];
		};
		
		// 比较隐蔽的错误代码
		JSValue *value = [JSValue valueWithObject:@"aaa"
		inContext:self.context];
		self.context[@"log"] = ^() {
			// 这个block里面使用了外部的value，value对context和它管理的JS对象都是强引用。这个value被block所捕获，同样也会内存泄漏，context是销毁不掉的。
			NSLog(@"%@", value);
		};
		
		// 正确代码， str对象是JS那边传递过来的
		self.context[@"log"] = ^(NSString *str) {
			NSLog(@"%@", str);
		};
		```
	2. OC对象不要用属性直接保存JSValue对象，因为这样太容易循环引用了。
	
		```
		// 定义一个JSExport protocol
		@protocol JSExportTest <JSExport>
		// 用来保存JS的对象
		@property (nonatomic, strong) JSValue *jsValue;
		@end
		
		// 建一个对象实现这个协议
		@interface JSProtocolObj: NSObject<JSExportTest>
		// 添加一个JSManagedValue用来保存JSValue
		@property (nonatomic, strong) JSManagedValue *managedValue;
		@end
		
		@implementation JSProtocolObj
		@synthesize jsValue = _jsValue;
		
		// 重写setter方法，此处是为了突出用JSManagedValue来保存JSValue。实际应该根据回调方法传进来的参数进行保存JSValue。
		- (void)setJsValue:(JSValue *)jsValue {
			_managedValue = [JSManagedValue managedValueWithValue:jsValue];
			[[[JSContext currentContext] virtualMachine] addManagedReference:_managedValue withOwner:self];
		}
		@end
		
		// 在VC中进行测试
		@interface ViewController () <JSExportTest>
		
		@property (nonatomic, strong) JSProtocolObj *obj;
		@property (nonatomic, strong) JSContext *context;
		
		@end
		
		@implementation ViewController
		
		- (void)viewDidLoad {
			[super viewDidLoad];
			// 创建context
			self.context = [[JSContext alloc] init];
			// 设置异常处理
			self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
				[JSContext currentContext].exception = exception;
				NSLog(@"exception:%@", exception);
			};
			// 加载JS代码到context中
			[self.context evaluateScript:@"function callback(){};
			function setObj(obj) {
				this.obj = obj;
				obj.jsValue = callback;
			}"];
			// 调用JS方法
			[self.context[@"setObj"] callWithArguments:@[self.obj]];
		}
		```
	3. 不要在不同的JSVirtualMachine之间进行传递JS对象。一个JSVirtualMachine可以运行多个context，由于都是在同一个堆内存和同一个垃圾回收下，所以相互之间传值是没有问题的。但是如果在不同的JSVirtualMachine传值，垃圾回收就不知道他们之间的关系了，可能会引起异常。
10. 与UIWebView的操作：不再通过URL拦截，直接获取UIWebView的context，然后进行对JS操作。

	```
	// 在UIWebView的finish的回调中进行获取。
	- (void)webViewDidFinishLoad:(UIWebView *)webView {
		// 使用了私有属性，可能会被拒，WKWebView不支持该属性。需注意的是每个页面加载完都是一个新的context，但是都是同一个JSVirtualMachine。如果JS调用OC方法进行操作UI时需注意线程是否是主线程，防止页面卡顿。
		self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
		// do something
	}
	```




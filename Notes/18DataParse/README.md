# 数据解析


#### JSON与XML对比
1. 可读性很好，xml的可读性相对比较好一些，描述性比较好。
2. 都具有很好的扩展性。
3. JSON的编码相对比较容易。
4. JSON的解码难度基本为零，xml需要考虑子节点和父节点。
5. JSON相对xml来讲，数据体积小，传递的速度更快些。
6. JSON与JavaScript的交互更加方便，更容易解析处理，更好的数据交互。
7. JSON传输速度远远快于xml。
 
#### JSON解析
1. 定义
  是一种轻量级的数据格式，一般用于数据交互。本质上是一个特殊格式的非NSString字符串。
2. 底层原理
	* 遍历字符串中的字符，最终根据格式规定的特殊字符，比如{}号，[]号，:号等进行区分，{}号是一个字典的开始，[]号是一个数组的开始，:号是字典的键和值的分水岭，最终乃是将json数据转化为字典，字典中值可能是字典，数组或字符串等。
3. JSON解析
  1. 第三方框架：JSONKit  > SBJson > TouchJSON (性能从左到右，越差)。
  2. 苹果原生NSJSONSerialization(性能最好)
    	* JSON数据 —> OC对象

			```
			+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error;
			```
     * OC对象 —> JSON数据
     
			```
			+ (NSData *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error;
			```
			
#### XML
1. 定义：和JSON一样，也是常用的一种用于交互的数据格式。
2. 文档声明：在XML文档的最前面，必须编写一个文档声明，用来声明XML文档的类型，如<?xml version=“1.0” encoding=“UTF-8” ?> // encoding属性说明文档的字符编码
3. 底层原理
	* xml解析常用方法有DOM解析和SAX解析。
	* DOM采用建立树形结构的方式访问xml文档，而SAX采用的事件模型。
	* DOM解析把xml文档转化为一个包含其内容的树，并可以对树进行遍历。
	* 使用DOM解析器的时候需要处理整个xml文档，所以对性能和内存的要求比较高。
	* SAX在解析xml文档的时候可以触发一序列的事件，当发现给定tag时它可以激活一个回调方法，告诉该方法制定的标签已经找到。
	* SAX对内存的要求通常会比较低，因为它让开发人员自己来决定所要处理的tag。特别是当开发人员只需要处理文档中所包含的部分数据时，SAX这种能力会得到更好的体现。
4. XML解析
   1. 第三方框架
      * libxml2：纯C语言，默认包含在iOS SDK中，同时支持DOM和SAX方式解析。
      * GDataXML：DOM方式解析，由Google开发，基于libxml2。
   2. 苹果原生NSXMLParser(SAX方式解析，使用简单)
      * 使用步骤

			```
			// 传入XML数据，创建解析器
			NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
			// 设置代理，监听解析过程
			parser.delegate = self;
			// 开始解析
			[parser parse];
			```
      * NSXMLParserDelegate
		
			```
			// 当扫描到文档的开始时调用(开始解析)
			- (void)parserDidStartDocument:(NSXMLParser *)parser;
			// 当扫描到文档的结束时调用(解析完毕)
			- (void)parserDidEndDocument:(NSXMLParser *)parser;
			// 当扫描到元素的开始时调用(attributeDict存放着元素的属性)
			- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
			// 当扫描到元素的结束时调用
			- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
			```




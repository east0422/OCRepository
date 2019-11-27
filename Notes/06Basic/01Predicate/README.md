# 谓词NSPredicate


#### 简述
1. 谓词就是通过NSPredicate给定的逻辑条件作为约束条件完成对数据的筛选。cocoa中提供了NSPredicate类，指定过滤器的条件，将符合条件的对象保留下来。
2. 简单使用
	```
	// 定义谓词对象(对象中包含了过滤条件)
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age<%d", 30];
	// 使用&&进行多条件过滤 predicate = [NSPredicate predicateWithFormat:@"name='1' && age>40"];
	// 包含语句 predicate = [NSPredicate predicateWithFormat:@"self.name IN {'1','2','4'} || self.age IN {30,40}"];
	// 同理有还有以什么开头BEGINSWITH，以什么结尾ENDSWITH，包含CONTAINS，匹配多个字符like，一个字符?等
	// 使用谓词条件过滤数组中的元素，过滤之后返回查询的结果
	NSArray *arr = [persons filteredArrayUsingPredicate:predicate];
	
	```




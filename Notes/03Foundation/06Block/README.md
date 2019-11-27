# Block


#### 简述
1. iOS中一种比较特殊的数据类型，用来保存某一段代码，可以在恰当的时间再取出来调用。
2. 默认情况下，Block内部不能修改外面的局部变量。
3. Block内部可以修改使用__block修饰的局部变量，__block修饰的局部变量的地址和Block内部使用的同名变量地址不相同。
4. 作为参数格式 返回值类型 (^)(形参列表)。
5. 定义格式 返回值类型 (^block变量名称)(形参列表); 
6. 实现格式 ^ 返回值类型 (形参列表){功能语句……}。
7. 无参无返回值 void (^block1)() = ^{NSLog(@“aaaaa”);}。
8. 有参无返回值   void (^block2)(NSString *name) = ^(NSString *name){NSLog(@“%@”,name)}。
9. 有参有返回值   void (^sum)(int num1, int num2) = ^(int num1, int num2){return num1 + num2;}。
10. 当在block内部使用对象时block内部会对这个对象增加一个强引用。
	



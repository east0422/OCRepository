##  使用运行时runtime归档
	1. 实现协议NSCoding。
	2. 重写initWithCoder和encodeWithCoder。
	3. 获取属性时使用class_copyIvarList([ClassName class], &count)而不要使用class_copyIvarList([self class], &count)。
	4. 子类归档和解档前记得调用[super initWithCoder:coder]和[super encodeWithCoder:coder]。
	5. 使用完成后记得释放free(ivars)。


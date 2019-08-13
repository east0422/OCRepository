#### 人脸标识
1. 如果UIImage使用CGImageRef初始化，那么它的属性CIImage为nil，需要使用`[[CIImage alloc] initWithImage:image]`创建。
2. 使用CIDetector初始化识别器定义好参数然后调用识别方法即可获取识别结果。
3. UIKit坐标是左上角为(0,0)往右x加往下y加，CoreImage框架坐标左下角为(0,0)往右x加往上y加，两个坐标系需要进行转换。
    


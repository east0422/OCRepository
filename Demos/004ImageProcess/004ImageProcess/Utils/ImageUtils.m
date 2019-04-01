//
//  ImageUtils.m
//  004ImageProcess
//
//  Created by dfang on 2019-3-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+ (UIImage *)imageWhitening:(UIImage *)originImage {
    // 一、获取原始图片大小
    // 方法一
//    CGFloat width = originImage.size.width;
//    CGFloat height = originImage.size.height;
    // 方法二
    CGImageRef imageRef = originImage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    // 二、开辟内存空间，用于创建颜色空间
    // 照片有黑白照和彩照两种，美白只能对彩照进行美白
//    CGColorSpaceRef grayColorSpaceRef = CGColorSpaceCreateDeviceGray(); // 灰色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB(); // 彩色空间
    
    // 三、创建图片上下文，解析图片信息
    // 参数1: 数据源
    // 1.1创建指针inputPixels: 指向图片的内存区域，方便通过指针操作像素点(内存)。图片其实是像素数组，inputPixels指向数组的第一个元素即第一个像素点(数组首地址)。
    // 1.2为什么是32位: 图片由一个个像素点构成，像素点由RGB或ARGB或R或G或B或RG等组合构成。像素点占内存最大组合为ARGB，A、R、G、B每个分量占用8位内存，每8位为1字节，最大为4字节，即32位。
    UInt32 *inputPixels = (UInt32 *)calloc(width * height, sizeof(UInt32));
    // 参数2: 图片的宽
    // 参数3: 图片的高
    // 参数4: 每个像素点每个分量的大小---8
    // 参数5: 每一行占用的内存大小(每一个像素点的内存（有4个字节）* width)
    // 参数6: 颜色空间
    // 参数7: 位图信息(7.1和指针大小保持一致即和像素大小一样；7.2是否包含透明度；7.3字节序)
    CGContextRef contextRef = CGBitmapContextCreate(inputPixels, width, height, 8, width * 4, colorSpaceRef, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // 四、根据图片上下文进行绘制
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    
    // 五、图片美白(操作像素点即操作ARGB分量值)
    // 修改分量的值--->增大，修改像素点、操作内存
    // 循环遍历像素点(从左到右，自上而下)，外层循环遍历行，内层循环遍历列
    // 0 ---> 255(黑到白，值越大越白)
    int light = 50; // 定义图片亮度
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            // 获取像素数组首地址
            UInt32 *curPixels = inputPixels + (width * i) + j;
            // 取出像素点的值&取地址，*取值
            UInt32 curColor = (*curPixels);
            // 操作ARGB的值，ARGB在内存中是有顺序的，可通过位运算获取到指定的颜色
            UInt32 curR = R(curColor);
            curR = curR + light > 255 ? 255: curR + light;
            UInt32 curG = G(curColor);
            curG = curG + light > 255 ? 255: curG + light;
            UInt32 curB = B(curColor);
            curB = curB + light > 255 ? 255: curB + light;
            UInt32 curA = A(curColor);
            
            // 修改像素点的值
            *curPixels = RGBA(curR, curG, curB, curA);
        }
    }
    
    // 六、创建UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // 七、释放内存
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRelease(contextRef);
    CGImageRelease(newImageRef);
    free(inputPixels);
    
    return newImage;
}

@end

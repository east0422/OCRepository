//
//  UIImage+CornerRadius.m
//  001UIImageView
//
//  Created by dfang on 2019-8-14.
//  Copyright © 2019年 east. All rights reserved.
//

#import "UIImage+CornerRadius.h"

@implementation UIImage (CornerRadius)

- (UIImage *)east_imageWithCornerRadius:(CGFloat)radius inBound:(CGRect)bounds {
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, UIScreen.mainScreen.scale);
    // 获取当前图形上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // 设置路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radius];
    // 将路径添加到上下文中
    CGContextAddPath(contextRef, bezierPath.CGPath);
    // 裁剪
    CGContextClip(contextRef);
    
    // 画图片
    [self drawInRect:bounds];
    
    // 获取当前上下文图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end

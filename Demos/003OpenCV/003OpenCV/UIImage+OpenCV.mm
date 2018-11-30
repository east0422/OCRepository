//
//  UIImage+OpenCV.m
//  003OpenCV
//
//  Created by dfang on 2018-11-29.
//  Copyright © 2018年 east. All rights reserved.
//

#import "UIImage+OpenCV.h"

@implementation UIImage (OpenCV)

+ (Mat)cvMatFromUIImage:(UIImage *)image isGray:(BOOL)isGray {
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorSpaceRef colorSpace;
    Mat mat;
    if (isGray) {
        bitmapInfo |= kCGImageAlphaNone;
        colorSpace = CGColorSpaceCreateDeviceGray();
        mat = Mat(rows, cols, CV_8UC1);
    } else {
        bitmapInfo |= kCGImageAlphaNoneSkipLast;
        colorSpace = CGImageGetColorSpace(image.CGImage);
        mat = Mat(rows, cols, CV_8UC4);
    }
    CGContextRef contextRef = CGBitmapContextCreate(mat.data, cols, rows, 8, mat.step[0], colorSpace, bitmapInfo);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return mat;
}

+ (UIImage *)imageFromCVMat:(Mat)mat {
    NSData *data = [NSData dataWithBytes:mat.data length:mat.elemSize()*mat.total()];
    CGColorSpaceRef colorSpaceRef;
    if (mat.elemSize() == 1) {
        colorSpaceRef = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(mat.cols, mat.rows, 8, 8 * mat.elemSize(), mat.step[0], colorSpaceRef, kCGImageAlphaNone | kCGBitmapByteOrderDefault, providerRef, NULL, false, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(providerRef);
    CGColorSpaceRelease(colorSpaceRef);
    return image;
}

@end

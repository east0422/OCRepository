//
//  ImageUtils.h
//  004ImageProcess
//
//  Created by dfang on 2019-3-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 定义常用宏
#define MaskB(x) ((x) & 0xFF)
#define R(x) (MaskB(x))
#define G(x) (MaskB(x >> 8))
#define B(x) (MaskB(x >> 16))
#define A(x) (MaskB(x >> 24))
#define RGBA(r,g,b,a) (MaskB(r) | MaskB(g)<<8 | MaskB(b) << 16 | MaskB(a) << 24)

// 图片工具类
@interface ImageUtils : NSObject

// 图片美白
+ (UIImage *)imageWhitening: (UIImage *)originImage;

@end

NS_ASSUME_NONNULL_END

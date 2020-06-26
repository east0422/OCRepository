//
//  CTDisplayView.m
//  002CoreTextDemo
//
// 持有CTData实例，负责将CTFrameRef绘制到界面上
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "CTDisplayView.h"

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置字形的变换矩阵为不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    // 将画布向上平移一个屏幕高
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    // x轴缩放系数为1则不变，y轴缩放系数为-1则相当于以x轴为轴旋转180度
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
        
        for (CTImageData *ctImageData in self.data.imageArr) {
            UIImage *image = [UIImage imageNamed:ctImageData.name];
            if (image) {
                CGContextDrawImage(context, ctImageData.position, image.CGImage);
            }
        }
    }
}
@end

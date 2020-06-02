//
//  CTHelloWorldView.m
//  001CoreTextHelloWorld
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "CTHelloWorldView.h"
#import <CoreText/CoreText.h>

@implementation CTHelloWorldView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
   
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // CoreText原点坐标在左下角，UI原点坐标在左上角，将CoreText坐标系进行转换使得两个原点坐标系重合
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 绘制矩形
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"Hello World!"];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attStr length]), path, NULL);
    // 绘制
    CTFrameDraw(frame, context);
    
    // 释放
    CFRelease(path);
    CFRelease(frameSetter);
    CFRelease(frame);
}


@end

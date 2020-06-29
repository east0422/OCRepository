//
//  MagnifierView.m
//  002CoreTextDemo
//
//  Created by dfang on 2020-6-29.
//  Copyright © 2020 east. All rights reserved.
//

#import "MagnifierView.h"

#define MAGNIFYSIZE 80

@implementation MagnifierView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, MAGNIFYSIZE, MAGNIFYSIZE)];
    if (self) {
        // 渲染一个圆
        self.layer.borderColor = UIColor.lightGrayColor.CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = MAGNIFYSIZE/2.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, MAGNIFYSIZE/2.0f, MAGNIFYSIZE/2.0f);
    CGContextScaleCTM(context, 1.5f, 1.5f);
    CGContextTranslateCTM(context, -1 * _touchPoint.x, -1 * _touchPoint.y);
    [self.viewToMagnify.layer renderInContext:context];
}

- (void)setTouchPoint:(CGPoint)touchPoint {
    _touchPoint = touchPoint;
    
    self.center = CGPointMake(touchPoint.x, touchPoint.y - MAGNIFYSIZE);
    
    // 标记需要重绘
    [self setNeedsDisplay];
}

@end

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
#import "MagnifierView.h"

#define debugLog NSLog(@"%s %@", __FILE__, NSStringFromSelector(_cmd))

@interface CTDisplayView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) MagnifierView *magnifierView;

@end

@implementation CTDisplayView

- (MagnifierView *)magnifierView {
    if (_magnifierView == nil) {
        _magnifierView = [[MagnifierView alloc] init];
        _magnifierView.viewToMagnify = self;
        
        [self addSubview:_magnifierView];
    }
    
    return _magnifierView;
}

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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addGestureRecognizerHandle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizerHandle];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addGestureRecognizerHandle];
    }
    return self;
}

/** 添加事件识别处理 */
- (void)addGestureRecognizerHandle {
    // 点击
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    // 长按
    UIGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    // 滑动
    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerHandle:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)tapGestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer {
//    debugLog;
    
    CGPoint point = [gestureRecognizer locationInView:self];
//    // 图片
//    for (CTImageData *imageData in self.data.imageArr) {
//        Boolean isAlert = [self showAlert:@"点击图片" withMessage:imageData.description ifUIPoint:point inCTRect:imageData.position];
//        if (isAlert) {
//            return;
//        }
//    }
//
//    // 链接
//    for (int i = 0; i < self.data.linkArr.count; i++) {
//        CTLinkData *linkData = self.data.linkArr[i];
//        for (int j = 0 ;j < linkData.positions.count; j++) {
//            NSValue *rectValue = linkData.positions[j];
//            Boolean isAlert = [self showAlert:@"点击链接" withMessage:linkData.description ifUIPoint:point inCTRect:rectValue.CGRectValue];
//            if (isAlert) {
//                return;
//            }
//        }
//    }

    CFIndex idx = [self offsetAtPoint:point];
    if (idx == kCFNotFound) {
        return;
    }
    // 图片
    // 判断占位符索引与文本点击一样不太精准，会向左偏移一半
    for (CTImageData *imageData in self.data.imageArr) {
        if (idx == imageData.index) {
            [self showAlert:@"点击图片" withContent:imageData.description];
            return;
        }
    }
    // 链接
    for (CTLinkData *linkData in self.data.linkArr) {
        if (NSLocationInRange(idx, linkData.range)) {
            [self showAlert:@"点击链接" withContent:linkData.description];
            return;
        }
    }
}

- (void)longPressGestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer {
//    debugLog;
    CGPoint point = [gestureRecognizer locationInView:self];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
        gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.magnifierView.touchPoint = point;
    } else {
        [self removeMaginfierView];
    }
}

- (void)panGestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer {
//    debugLog;
}

#pragma --- UIGestureRecognizerDelegate
// 允许多个相似手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

- (Boolean)showAlert:(NSString *)title withMessage:(NSString *)message ifUIPoint:(CGPoint)uiPoint inCTRect:(CGRect)ctRect {
    CGPoint origin = ctRect.origin;
    origin.y = self.bounds.size.height - ctRect.origin.y - ctRect.size.height;
    CGRect rect = CGRectMake(origin.x, origin.y, ctRect.size.width, ctRect.size.height);
    // 检测点击位置是否在rect之内
    if (CGRectContainsPoint(rect, uiPoint)) {
        // 在这里处理点击后的逻辑
        [self showAlert:title withContent:message];
        return true;
    }
    return false;
}

- (void)showAlert:(NSString *)title withContent:(NSString *)content {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    
    [UIApplication.sharedApplication.windows.firstObject.rootViewController presentViewController:alert animated:YES completion:nil];
}

// point点在当前视图data中的偏移量
- (CFIndex)offsetAtPoint:(CGPoint)point {
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);

    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);

    // 翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);

    CFIndex idx = kCFNotFound;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        // 1. 使用transform转换
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        // 2. 手动计算转换
//        CGRect rect = CGRectMake(flippedRect.origin.x, self.bounds.size.height - flippedRect.origin.y - flippedRect.size.height, flippedRect.size.width, flippedRect.size.height);
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect), point.y-CGRectGetMinY(rect));
            // 获得当前点击坐标对应的字符索引
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
            
            // 点击图片左半边响应，右半边不响应；链接首文字前一个非链接文字右半边会响应，链接尾文字右半边不会响应
            // fix left side hand but right side not hand
            CGFloat secondaryOffset;
            CGFloat primaryOffset = CTLineGetOffsetForStringIndex(line, idx, &secondaryOffset);
//            NSLog(@"idx:%ld, primaryOffset:%f, secondaryOffset:%f", (long)idx, primaryOffset, secondaryOffset);
            if (relativePoint.x < primaryOffset && (idx > 0)) {
                --idx;
            }
            break;
        }
    }
    return idx;
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent + leading;
    return CGRectMake(point.x, point.y - descent, width, height);
}

- (void)removeMaginfierView {
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}
@end

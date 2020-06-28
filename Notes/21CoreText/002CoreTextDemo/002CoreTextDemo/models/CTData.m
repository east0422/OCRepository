//
//  CTData.m
//  002CoreTextDemo
//
//  用于保存由CTFrameParser类生成的CTFrameRef实例，以及CTFrameRef实际绘制需要的高度
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "CTData.h"

@implementation CTData

- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr;
    [self fillImagePosition];
}

- (void)fillImagePosition {
    if (self.imageArr.count == 0) {
        return;
    }
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    CTImageData * imageData = self.imageArr[0];
    
    for (int i = 0; i < lineCount; ++i) {
        if (imageData == nil) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
//        NSLog(@"ii:%d count: %lu", i , (unsigned long)runObjArray.count);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) { // 图片解析显示设置了kCTRunDelegateAttributeName值
                continue;
            }
            
            NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.position = delegateBounds;
            imgIndex++;
            if (imgIndex == self.imageArr.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imageArr[imgIndex];
            }
        }
    }
}

- (void)setLinkArr:(NSArray<CTLinkData *> *)linkArr {
    _linkArr = linkArr;
    [self fillLinkPosition];
}

// 如果链接是多行，则只会将最前面的一行区域加入进去
- (void)fillLinkPosition {
    if (self.linkArr.count == 0) {
        return;
    }
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int linkIndex = 0;
    CTLinkData * linkData = self.linkArr[0];
    
    // 一行中最后一个CTRun是否为link链接，防止一个长链接占据多行
    Boolean linkEnd = false;
    for (int i = 0; i < lineCount; ++i) {
        if (linkData == nil) {
            break;
        }
        if (!linkEnd) {
            linkData.positions = [NSMutableArray array];
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        NSUInteger runCount = runObjArray.count;
//        NSLog(@"i:%d count: %lu", i,(unsigned long)runCount);
        for (int j = 0; j < runCount; j++) {
            CTRunRef run = (__bridge CTRunRef)(runObjArray[j]);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CFNumberRef underlineStyle = (__bridge CFNumberRef)[runAttributes valueForKey:(id)kCTUnderlineStyleAttributeName];
//            NSLog(@"underlineStyle:%@",underlineStyle);
            if (underlineStyle == nil) { // 非链接执行下一个CTRun
                linkEnd = false;
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            [linkData.positions addObject:[NSValue valueWithCGRect:delegateBounds]];
            if (j == runCount - 1) { // 链接在末尾
                linkEnd = true;
                continue;
            }
            linkIndex++;
            if (linkIndex == self.linkArr.count) {
                linkData = nil;
                break;
            } else {
                linkData = self.linkArr[linkIndex];
            }
        }
    }
}

- (void)dealloc
{
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

@end

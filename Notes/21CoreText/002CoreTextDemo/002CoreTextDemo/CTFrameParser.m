//
//  CTFrameParser.m
//  002CoreTextDemo
//
// 用于生成最后绘制界面需要的CTFrameRef实例
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "CTFrameParser.h"
#import <CoreText/CoreText.h>

@implementation CTFrameParser

+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config {
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", config.fontSize, NULL);
    const CFIndex kNumberOfSettings = 3;
    CGFloat lineSpacing = config.lineSpace;
//    CTTextAlignment alignment = kCTTextAlignmentCenter;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
//        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing}
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor *textColor = config.textColor;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = textColor;
    dict[NSFontAttributeName] = (__bridge id _Nullable)(fontRef);
    dict[NSParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
//    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
//    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
//    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    
    return dict;
}

+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict config:(CTFrameParserConfig*)config {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));

    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

+ (CTData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config {
    // 创建CTFrameSetterRef实例
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize ctSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = ctSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFrameSetter:frameSetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的绘制高度保存到CTData实例中，最后返回CTData实例
    CTData *data = [[CTData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    // 释放
    CFRelease(frame);
    CFRelease(frameSetter);
    
    return data;
}

+ (CTData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config {
    NSDictionary *attrs = [self attributesWithConfig:config];
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:content attributes:attrs];
    
    return [self parseAttributedContent:attStr config:config];
}

+ (CTFrameRef)createFrameWithFrameSetter:(CTFramesetterRef)frameSetter config:(CTFrameParserConfig *)config height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    CFRelease(path);
    
    return frame;
}

static CGFloat ascentCallback(void * ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void * ref) {
    return 0;
}

static CGFloat widthCallback(void * ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

@end

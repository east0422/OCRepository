//
//  CTFrameParserConfig.m
//  002CoreTextDemo
//
// 用于配置绘制的参数，例如文字颜色、大小，行间距等
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    }
    return self;
}

@end

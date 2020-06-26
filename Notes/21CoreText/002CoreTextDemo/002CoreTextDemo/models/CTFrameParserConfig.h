//
//  CTFrameParserConfig.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTFrameParserConfig : NSObject

/** 宽度 */
@property (nonatomic, assign) CGFloat width;
/** 文本字体大小 */
@property (nonatomic, assign) CGFloat fontSize;
/** 文本颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 行距 */
@property (nonatomic, assign) CGFloat lineSpace;

@end

NS_ASSUME_NONNULL_END

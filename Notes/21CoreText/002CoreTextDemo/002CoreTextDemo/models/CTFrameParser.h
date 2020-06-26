//
//  CTFrameParser.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTData.h"
#import "CTImageData.h"
#import "CTLinkData.h"
#import "CTFrameParserConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFrameParser : NSObject

+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict config:(CTFrameParserConfig*)config;
+ (CTData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config;
/** 以配置标准解析内容  */
+ (CTData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config;
/** 解析指定路径文件内容 */
+ (CTData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config;

@end

NS_ASSUME_NONNULL_END

//
//  CTData.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTImageData.h"
#import "CTLinkData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTData : NSObject

/** Core text frame对象引用，是结构体类型 */
@property (nonatomic, assign) CTFrameRef ctFrame;
/** 高度 */
@property (nonatomic, assign) CGFloat height;
/** 图片对象数组 */
@property (nonatomic, strong) NSArray<CTImageData *> *imageArr;
/** 链接对象数组 */
@property (nonatomic, strong) NSArray<CTLinkData *> *linkArr;
/** 显示内容 */
@property (nonatomic, copy) NSAttributedString *content;

@end

NS_ASSUME_NONNULL_END

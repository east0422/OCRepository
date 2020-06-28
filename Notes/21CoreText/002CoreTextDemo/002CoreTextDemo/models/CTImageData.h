//
//  CTImageData.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTImageData : NSObject

/** 图片名称 */
@property (nonatomic, copy) NSString *name;
/** 图片占位符插入位置 */
@property (nonatomic, assign) NSInteger index;
/** 图片显示位置(CoreText坐标系) */
@property (nonatomic, assign) CGRect position;

@end

NS_ASSUME_NONNULL_END

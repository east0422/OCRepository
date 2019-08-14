//
//  UIImage+CornerRadius.h
//  001UIImageView
//
//  Created by dfang on 2019-8-14.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CornerRadius)

// 依据radius设置图片圆角
- (UIImage *)east_imageWithCornerRadius:(CGFloat)radius inBound:(CGRect)bounds;

@end

NS_ASSUME_NONNULL_END

//
//  MagnifierView.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-6-29.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MagnifierView : UIView

/** 需要放大的视图 */
@property (nonatomic, weak) UIView *viewToMagnify;
/** 放大视图点击位置内容 */
@property (nonatomic, assign) CGPoint touchPoint;

@end

NS_ASSUME_NONNULL_END

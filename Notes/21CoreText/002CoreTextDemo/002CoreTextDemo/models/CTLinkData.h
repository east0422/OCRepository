//
//  CTLinkData.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-6-25.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLinkData : NSObject

/** 显示标题内容 */
@property (nonatomic, copy) NSString *title;
/** 链接跳转地址 */
@property (nonatomic, copy) NSString *url;
/** 链接文字显示位置(CoreText坐标系) */
@property (nonatomic, assign) NSRange range;

@end

NS_ASSUME_NONNULL_END

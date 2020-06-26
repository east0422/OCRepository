//
//  CTLinkData.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-6-25.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTLinkData : NSObject

/** 显示标题内容 */
@property (nonatomic, copy) NSString *title;
/** 链接跳转地址 */
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END

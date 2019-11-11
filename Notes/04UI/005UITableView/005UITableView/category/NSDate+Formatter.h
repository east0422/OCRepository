//
//  NSDate+Formatter.h
//  005UITableView
//
//  Created by dfang on 2019-11-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Formatter)

/** 获取当前时间以YYYY-MM-dd HH:mm:ss格式返回 */
+ (NSString *)currentDateString;

/** 转化为YYYY-MM-dd HH:mm:ss格式字符串 */
- (NSString *)formatString;
/** 将时间转换为指定格式字符串(注意格式字符串有一定要求) */
- (NSString *)convertWithFormat:(NSString *)formatStr;

@end

NS_ASSUME_NONNULL_END

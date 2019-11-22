//
//  AppInfo.h
//  003NSOperation
//
//  Created by dfang on 2019-11-22.
//  Copyright © 2019 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppInfo : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 下载次数 */
@property (nonatomic, copy) NSString *download;

/** 字典实例化appInfo模型对象 */
+ (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

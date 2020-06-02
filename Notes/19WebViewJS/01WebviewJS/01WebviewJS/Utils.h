//
//  Utils.h
//  01WebviewJS
//
//  Created by dfang on 2020-5-27.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

/** 获取rootViewController */
+ (UIViewController *)rootVC;
/** 获取navigationController */
+ (UINavigationController *)navVC;
/** 弹出框 */
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
/** 显示message，2秒后自动消失 */
+ (void)showMessage:(NSString *)message;
/** 显示message，delay秒后消失 */
+ (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END

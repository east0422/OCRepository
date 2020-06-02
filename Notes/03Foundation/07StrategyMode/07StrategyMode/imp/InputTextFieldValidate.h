//
//  InputTextFieldValidate.h
//  07StrategyMode
//
//  Created by dfang on 2020-5-22.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputTextFieldValidate : NSObject

/** 存储校验结果字符串 */
@property (nonatomic, copy) NSString *validateResult;

/** 校验满足返回YES，否则返回NO */
- (BOOL)validateInputTextField:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END

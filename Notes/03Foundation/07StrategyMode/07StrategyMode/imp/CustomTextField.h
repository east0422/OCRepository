//
//  CustomTextField.h
//  07StrategyMode
//
//  Created by dfang on 2020-5-22.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTextFieldValidate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomTextField : UITextField

/** 自定义输入框校验 */
@property (nonatomic, strong) InputTextFieldValidate *inputTextFieldValidate;

/** 校验成功返回YES，否则返回NO */
- (BOOL)validate;

@end

NS_ASSUME_NONNULL_END

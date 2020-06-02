//
//  InputTextField.h
//  07StrategyMode
//
//  Created by dfang on 2020-5-23.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTextFieldValidateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface InputTextField : UITextField

/** 校验协议 */
@property (nonatomic, strong) id<InputTextFieldValidateProtocol> validateProtocol;

/** 执行验证并将验证结果展现到validateLabel上 */
- (BOOL)performValidateAndDisplayIn:(UILabel *)validateLabel;

@end

NS_ASSUME_NONNULL_END

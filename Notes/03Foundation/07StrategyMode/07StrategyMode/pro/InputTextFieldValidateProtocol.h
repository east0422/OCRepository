//
//  InputTextFieldValidateProtocol.h
//  07StrategyMode
//
//  Created by dfang on 2020-5-23.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 输入框校验协议
@protocol InputTextFieldValidateProtocol <NSObject>

// 默认是required
@required
/** 校验并将校验结果展示到resultLabel上 */
- (BOOL)validateInputTextField:(UITextField *)textField displayResultInLabelL:(UILabel *)resultLabel;

@end

NS_ASSUME_NONNULL_END

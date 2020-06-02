//
//  NumInputTextFieldValidate.m
//  07StrategyMode
//
//  Created by dfang on 2020-5-22.
//  Copyright © 2020 east. All rights reserved.
//

#import "NumInputTextFieldValidate.h"

@implementation NumInputTextFieldValidate

- (BOOL)validateInputTextField:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.validateResult = @"不能为空!";
        return NO;
    }
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]*$" options:(NSRegularExpressionAnchorsMatchLines) error:nil];
    NSUInteger numberOfMatches = [reg numberOfMatchesInString:textField.text options:(NSMatchingAnchored) range:NSMakeRange(0, textField.text.length)];
    if (numberOfMatches == 0) {
        self.validateResult = @"错误，不全为数字!";
    } else {
        self.validateResult = @"正确，全为数字!";
    }
    return numberOfMatches != 0;
}

@end

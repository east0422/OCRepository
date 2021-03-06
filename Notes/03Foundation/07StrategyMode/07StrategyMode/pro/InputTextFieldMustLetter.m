//
//  InputTextFieldMustLetter.m
//  07StrategyMode
//
//  Created by dfang on 2020-5-23.
//  Copyright © 2020 east. All rights reserved.
//

#import "InputTextFieldMustLetter.h"

@implementation InputTextFieldMustLetter

- (BOOL)validateInputTextField:(UITextField *)textField displayResultInLabelL:(UILabel *)resultLabel {
    if (textField.text.length == 0) {
        resultLabel.text = @"11- 不能为空";
        resultLabel.textColor = [UIColor redColor];
        return NO;
    }
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z]*$" options:(NSRegularExpressionAnchorsMatchLines) error:nil];
    NSUInteger numberOfMatches = [reg numberOfMatchesInString:textField.text options:(NSMatchingAnchored) range:NSMakeRange(0, textField.text.length)];
    if (numberOfMatches == 0) {
        resultLabel.text = @"11- 错误，不全为字母!";
        resultLabel.textColor = [UIColor redColor];
    } else {
        resultLabel.text = @"11- 正确，全为字母!";
        resultLabel.textColor = [UIColor greenColor];
    }
    return numberOfMatches != 0;
}

@end

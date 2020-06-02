//
//  InputTextField.m
//  07StrategyMode
//
//  Created by dfang on 2020-5-23.
//  Copyright © 2020 east. All rights reserved.
//

#import "InputTextField.h"

@implementation InputTextField

- (BOOL)performValidateAndDisplayIn:(UILabel *)validateLabel {
    return [self.validateProtocol validateInputTextField:self displayResultInLabelL:validateLabel];
}

@end

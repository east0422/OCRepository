//
//  CustomTextField.m
//  07StrategyMode
//
//  Created by dfang on 2020-5-22.
//  Copyright © 2020 east. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (BOOL)validate {
    return [self.inputTextFieldValidate validateInputTextField:self];
}

@end

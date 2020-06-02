//
//  ImpViewController.m
//  07StrategyMode
//
//  Created by dfang on 2020-5-22.
//  Copyright © 2020 east. All rights reserved.
//

#import "ImpViewController.h"
#import "CustomTextField.h"
#import "LetterInputTextFieldValidate.h"
#import "NumInputTextFieldValidate.h"

@interface ImpViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *letterTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *letterVerify;
@property (weak, nonatomic) IBOutlet UILabel *numVerify;

@end

@implementation ImpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.letterTextField.delegate = self;
    self.numTextField.delegate = self;
    
    self.letterTextField.inputTextFieldValidate = [LetterInputTextFieldValidate new];
    self.numTextField.inputTextFieldValidate = [NumInputTextFieldValidate new];
}

- (IBAction)verifyBtnClicked:(UIButton *)sender {
    [self.view endEditing:YES];
}

#pragma mark --- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[CustomTextField class]]) {
        BOOL isPass = [(CustomTextField *)textField validate];
        switch (textField.tag) {
            case 111: // letter
                self.letterVerify.text = self.letterTextField.inputTextFieldValidate.validateResult;
                if (isPass) {
                    self.letterVerify.textColor = [UIColor greenColor];
                } else {
                    self.letterVerify.textColor = [UIColor redColor];
                }
                break;
            case 222: // number
                self.numVerify.text = self.numTextField.inputTextFieldValidate.validateResult;
                if (isPass) {
                    self.numVerify.textColor = [UIColor greenColor];
                } else {
                    self.numVerify.textColor = [UIColor redColor];
                }
                break;
            default:
                break;
        }
    }
}

@end

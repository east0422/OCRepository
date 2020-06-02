//
//  ProViewController.m
//  07StrategyMode
//
//  Created by dfang on 2020-5-23.
//  Copyright © 2020 east. All rights reserved.
//

#import "ProViewController.h"
#import "InputTextField.h"
#import "InputTextFieldMustLetter.h"
#import "InputTextFieldMustNumber.h"

@interface ProViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet InputTextField *letterTextField;
@property (weak, nonatomic) IBOutlet InputTextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *letterVerify;
@property (weak, nonatomic) IBOutlet UILabel *numVerify;

@end

@implementation ProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.letterTextField.delegate = self;
    self.numTextField.delegate = self;
    
    self.letterTextField.validateProtocol = [InputTextFieldMustLetter new];
    self.numTextField.validateProtocol = [InputTextFieldMustNumber new];
}

- (IBAction)verifyBtnClicked:(id)sender {
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[InputTextField class]]) {
        switch (textField.tag) {
            case 111: // letter
                [(InputTextField *)textField performValidateAndDisplayIn:self.letterVerify];
                break;
            case 222: // number
                [(InputTextField *)textField performValidateAndDisplayIn:self.numVerify];
                break;
            default:
                break;
        }
    }
}

@end

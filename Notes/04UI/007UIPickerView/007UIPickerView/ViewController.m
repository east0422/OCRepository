//
//  ViewController.m
//  007UIPickerView
//
//  Created by dfang on 2020-5-27.
//  Copyright © 2020 east. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ViewController

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
        
        int sight = -1000;
        while (sight <= 1000) {
            if (sight < 0) {
                [_dataList addObject:[NSString stringWithFormat:@"近视%d", -sight]];
            } else if (sight > 0) {
                 [_dataList addObject:[NSString stringWithFormat:@"远视%d", sight]];
            } else {
                [_dataList addObject:@"平光"];
            }
            sight += 25;
        }
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加边框
    self.pickerView.layer.borderColor = [UIColor systemPinkColor].CGColor;
    self.pickerView.layer.borderWidth = 1.0f;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    // 默认选中
    NSInteger defaultRow = [self.dataList indexOfObject:@"平光"];
    [self.pickerView selectRow:defaultRow inComponent:0 animated:YES];
}

#pragma --- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return  self.dataList.count;
}

#pragma --- UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataList[row];
}


@end

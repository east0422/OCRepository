//
//  RedView.h
//  003RAC
//
//  Created by dfang on 2019-9-17.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickedBlock)(id);

@interface RedView : UIView

@property (nonatomic, strong) ClickedBlock btnClickedblock;

@property (weak, nonatomic) IBOutlet UIButton *btn;

- (IBAction)btnClicked:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END

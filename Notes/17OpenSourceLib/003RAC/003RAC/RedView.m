//
//  RedView.m
//  003RAC
//
//  Created by dfang on 2019-9-17.
//  Copyright © 2019年 east. All rights reserved.
//
///////  注意：xib视图类名不能填，只匹配File's Owner的Custom Class ///////

#import "RedView.h"

@implementation RedView

// initWithFrame只适用纯代码创建时调用，不涉及xib或storyboard
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
//    NSLog(@"redview initWithFrame");
    if (self) {
        [self setupWithXib];
    }
    return self;
}

// 当控件是从xib、storyboard中创建时(你的view在xib或storyboard上有体现，比如直接用xib创建的或控件关联已有类等)
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
//    NSLog(@"redview initWithCoder");
    if (self) {
        [self setupWithXib];
    }
    return self;
}

// 在initWithCoder:方法后调用
- (void)awakeFromNib {
    [super awakeFromNib];
//    NSLog(@"awakeFromNib");
}

- (void)setupWithXib {
//    NSLog(@"classname:%@", NSStringFromClass(self.class));
    UIView *contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] lastObject];
    contentView.frame = self.bounds;
    [self addSubview:contentView];
}

- (IBAction)btnClicked:(UIButton *)sender {
    NSLog(@"RedView btn clicked!");
    
    // notification
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"redview" object:sender];
    
    // block
//    if (self.btnClickedblock) {
//        self.btnClickedblock(sender);
//    } else {
//        NSLog(@"no btnClickedblock");
//    }
}

@end

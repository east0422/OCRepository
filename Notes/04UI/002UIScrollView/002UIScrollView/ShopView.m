//
//  ShopView.m
//  002UIScrollView
//
//  Created by dfang on 2019-9-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ShopView.h"

@interface ShopView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ShopView

+ (instancetype)shopView {
    // name: The name of the nib file, which need not include the .nib extension.
    // owner: The object to assign as the nib’s File's Owner object.
    // options: A dictionary containing the options to use when opening the nib file. For a list of available keys for this dictionary, see UIKit Nib Loading Options.
    //    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
    // 先获取nib
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]];
    // 再获取nib文件对应的视图数组，一个xib中也可有多个view，但通常我们每个xib中只放一个view，所以使用firstObject或lastObject都可以
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    
    return [views firstObject];
}

// 使用纯代码方式创建，init和initWithFrame:都会调用该方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [ShopView shopView];
        // note: 需要重设frame，否则传递过来的frame就失效了
        self.frame = frame;
    }
    return self;
}

// note: 加载xib文件会触发该方法，上面shopView中有加载xib文件，所以该方法中不可再调用shopView，否则会死循环
//- (void)awakeFromNib {
//    [super awakeFromNib];
//}

- (void)setModel:(ShopModel *)model {
    _model = model;
    self.imageView.image = [UIImage imageNamed:model.iconName];
    self.label.text = model.title;
}

@end

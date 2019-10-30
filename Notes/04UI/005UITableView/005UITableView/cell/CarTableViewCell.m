//
//  CarTableViewCell.m
//  005UITableView
//
//  Created by dfang on 2019-10-28.
//  Copyright © 2019年 east. All rights reserved.
//

#import "CarTableViewCell.h"
#import "Masonry.h"

@interface CarTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation CarTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    CarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSECELLID];
    if (!cell) {
        cell = [[CarTableViewCell alloc] init];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

// 外界注册
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

// 布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.bottom.mas_offset(-10);
        make.width.mas_equalTo(80);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(25);
        make.centerY.mas_equalTo(-20);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.nameLabel);
        make.left.mas_lessThanOrEqualTo(self.nameLabel.mas_left);
        make.centerY.mas_equalTo(20);
    }];
}

// 初始化子视图
- (void)initSubViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
}

#pragma mark --- 懒加载子视图
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = UIColor.redColor;
        _priceLabel.font = [UIFont systemFontOfSize:14];
    }
    return _priceLabel;
}

// 网络下载完图片在主线程更新ui
- (void)downloadImageWithPath: (NSString *)iconPath
{
    NSURL *imageUrl = [NSURL URLWithString:iconPath];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    // self.iconImageView.image = image; // 需要在主线程更新
    [self.iconImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}

// 设置car属性
- (void)setCar:(CarModel *)car {
    _car = car;
    self.nameLabel.text = car.name;
    self.priceLabel.text = car.price;
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageWithPath:) object:car.icon];
    [operationQueue addOperation:op];
}

@end

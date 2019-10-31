//
//  DifferHeightTableViewCell.m
//  005UITableView
//
//  Created by dfang on 2019-10-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import "DifferHeightTableViewCell.h"
#import "DifferHeightModel.h"
#import "Masonry.h"

@interface DifferHeightTableViewCell ()

@property (nonatomic, strong) UIImageView *avtarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *vipImageView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIView *separatorView; // 分割视图

@end

@implementation DifferHeightTableViewCell

+ (instancetype)cellWithTableview:(UITableView *)tableView {
    DifferHeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DIFFERREUSECELLID];
    if (cell == nil) {
        cell = [[self alloc] init];
    }
    return cell;
}

// 外界注册后调用dequeueReusableCellWithIdentifier不会走initWithFrame而是走initWithStyle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

// 布局子视图
- (void)layoutSubviews {
    [self.avtarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.width.height.mas_equalTo(30);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_equalTo(self.avtarImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.avtarImageView.mas_centerY);
    }];
    [self.vipImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(10);
    }];
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avtarImageView.mas_bottom).mas_offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    [self.pictureImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(200);
        if (self.detailLabel.isHidden) {
            make.top.mas_equalTo(self.avtarImageView.mas_bottom).mas_offset(10);
        } else {
            make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_offset(10);
        }
    }];
    [self.separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)updateConstraintsIfNeeded {
    [self.pictureImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(200);
        if (self.detailLabel.isHidden) {
            make.top.mas_equalTo(self.avtarImageView.mas_bottom).mas_offset(10);
        } else {
            make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_offset(10);
        }
    }];
    [super updateConstraintsIfNeeded];
}

// 初始化子视图
- (void)initSubViews {
    [self.contentView addSubview:self.avtarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.vipImageView];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.pictureImageView];
    [self.contentView addSubview:self.separatorView];
}

#pragma mark -- property getter method
- (UIImageView *)avtarImageView {
    if (_avtarImageView == nil) {
        _avtarImageView = [[UIImageView alloc] init];
    }
    return _avtarImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UIImageView *)vipImageView {
    if (_vipImageView == nil) {
        _vipImageView = [[UIImageView alloc] init];
        _vipImageView.image = [UIImage imageNamed:@"vip"];
    }
    return _vipImageView;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        // 设置内容过多自动换行
        _detailLabel.numberOfLines = 0;
        // 想要文字高度计算正确，必须给每一行文字设置最大宽度，如果约束已经限制最大宽度可不设置
        _detailLabel.preferredMaxLayoutWidth = UIScreen.mainScreen.bounds.size.width - 20;
    }
    return _detailLabel;
}

- (UIImageView *)pictureImageView {
    if (_pictureImageView == nil) {
        _pictureImageView = [[UIImageView alloc] init];
        // 图片填充方式
        _pictureImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _pictureImageView;
}

- (UIView *)separatorView {
    if (_separatorView == nil) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = UIColor.grayColor;
    }
    return _separatorView;
}

// 重写setter方法
- (void)setDifferModel:(DifferHeightModel *)differModel {
    _differModel = differModel;
    self.avtarImageView.image = [UIImage imageNamed:differModel.icon];
    self.nameLabel.text = differModel.name;
    if (differModel.isVip) {
        self.nameLabel.textColor = UIColor.orangeColor;
    } else {
        self.nameLabel.textColor = UIColor.blackColor;
    }
    self.vipImageView.hidden = !differModel.isVip;
    if (differModel.text && ![differModel.text isEqualToString:@""]) { // 如果有text值就赋值显示，否则就隐藏
        self.detailLabel.text = differModel.text;
        self.detailLabel.hidden = NO;
    } else {
        self.detailLabel.hidden = YES;
    }
    if (differModel.picture && ![differModel.picture isEqualToString:@""]) { // 如果picture有值就赋值显示，否则就隐藏
        self.pictureImageView.image = [UIImage imageNamed:differModel.picture];
        self.pictureImageView.hidden = NO;
        // 放在这里避免每次调用
        [self updateConstraintsIfNeeded];
    } else {
        self.pictureImageView.hidden = YES;
    }
    
    // 强制布局，更新ui后再计算cell高度，否则计算的是以前的高度
    // 如果有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews）
    [self layoutIfNeeded];
    
    CGFloat cellHeight = 100;
    if (!self.pictureImageView.isHidden) {
        cellHeight = CGRectGetMaxY(self.pictureImageView.frame);
    } else if (!self.detailLabel.isHidden) {
        cellHeight = CGRectGetMaxY(self.detailLabel.frame);
    } else {
        cellHeight = CGRectGetMaxY(self.avtarImageView.frame);
    }
    differModel.cellHeight = cellHeight + 5;
}

@end

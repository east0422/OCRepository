//
//  ChatMessageTableViewCell.m
//  005UITableView
//
//  Created by dfang on 2019-11-1.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#import "ChatMessageModel.h"
#import "Masonry.h"

@interface ChatMessageTableViewCell ()

/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 他人头像 */
@property (nonatomic, strong) UIImageView *otherAvatarImageView;
/** 他人消息内容 */
@property (nonatomic, strong) UIButton *otherContentBtn;
/** 自己图像 */
@property (nonatomic, strong) UIImageView *myAvatarImageView;
/** 自己消息内容 */
@property (nonatomic, strong) UIButton *myContentBtn;

@end

@implementation ChatMessageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHATMESSAGEREUSECELLID];
    if (cell == nil) {
        cell = [[self alloc] init];
    }
    return cell;
}

/** 以代码alloc init/initWithFrame创建会调用 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

/** 外面注册后使用dequeueReusableCellWithIdentifier会调用它而不会调用init */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

/** 布局子视图 */
- (void)layoutSubviews {
    // 使用自动布局需要将translatesAutoresizingMaskIntoConstraints设置为NO,Masonry框架已默认将其设为NO
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(5);
        make.right.mas_offset(-5);
        make.height.mas_equalTo(15);
    }];
    [self.otherAvatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.timeLabel.isHidden) {
            make.top.mas_equalTo(5);
        } else {
            make.top.mas_equalTo(25);
        }
        make.left.mas_offset(5);
        make.width.height.mas_equalTo(30);
    }];
    [self.otherContentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.otherAvatarImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.otherAvatarImageView.mas_top).mas_offset(5);
        make.width.mas_lessThanOrEqualTo(200);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self.myAvatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.timeLabel.isHidden) {
            make.top.mas_equalTo(5);
        } else {
            make.top.mas_equalTo(25);
        }
        make.right.mas_offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    [self.myContentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myAvatarImageView.mas_top).mas_offset(5);
        make.right.mas_equalTo(self.myAvatarImageView.mas_left).mas_offset(-5);
        make.width.mas_lessThanOrEqualTo(200);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
}

/** 初始化子视图 */
- (void)initSubviews {
    // 设置背景透明，使用背景色
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.otherAvatarImageView];
    [self.contentView addSubview:self.otherContentBtn];
    [self.contentView addSubview:self.myAvatarImageView];
    [self.contentView addSubview:self.myContentBtn];
}

/** 设置模型数据 */
- (void)setChatMessage:(ChatMessageModel *)chatMessage {
    _chatMessage = chatMessage;
    
    [self.timeLabel setText:chatMessage.time];
    self.timeLabel.hidden = chatMessage.isHideTime;
    
    if (chatMessage.type == ChatMessageOther) {
        [self showAvatarView:self.otherAvatarImageView showContentBtn:self.otherContentBtn hideAvatarView:self.myAvatarImageView hideContentBtn:self.myContentBtn];
    } else {
        [self showAvatarView:self.myAvatarImageView showContentBtn:self.myContentBtn hideAvatarView:self.otherAvatarImageView hideContentBtn:self.otherContentBtn];
    }
}

/** 将需要显示和隐藏的控件传递过来进行数据赋值 */
- (void)showAvatarView:(UIImageView *)showAvatarView showContentBtn:(UIButton *)showBtn hideAvatarView:(UIImageView *)hideAvatarView hideContentBtn:(UIButton *)hideBtn {
    showAvatarView.hidden = NO;
    showBtn.hidden = NO;
    hideAvatarView.hidden = YES;
    hideBtn.hidden = YES;
    
    [showBtn setTitle:self.chatMessage.msg forState:(UIControlStateNormal)];
   
    [showAvatarView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.timeLabel.isHidden) {
            make.top.mas_offset(5);
        } else {
            make.top.mas_equalTo(25);
        }
    }];
    
    [showBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(showBtn.titleLabel.mas_height).mas_offset(10);
    }];
    // 优先级高于...edgeInsets属性，所以设置edgeInsets属性会失效
    [showBtn.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        // 使用edges会有约束冲突
        make.top.mas_offset(5);
        make.bottom.mas_offset(-5);
        
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
    }];
    
    // 立即刷新
    [self layoutIfNeeded];
    
    self.chatMessage.cellHeight = MAX(CGRectGetMaxY(showAvatarView.frame), CGRectGetMaxY(showBtn.frame)) + 5;
}

#pragma mark -- 懒加载子视图控件
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColor.grayColor;
    }
    return _timeLabel;
}

- (UIImageView *)otherAvatarImageView {
    if (_otherAvatarImageView == nil) {
        _otherAvatarImageView = [[UIImageView alloc] init];
        _otherAvatarImageView.contentMode = UIViewContentModeScaleToFill;
        _otherAvatarImageView.image = [UIImage imageNamed:@"other"];
        _otherAvatarImageView.contentMode = UIViewContentModeScaleToFill;
       
    }
    return _otherAvatarImageView;
}

- (UIButton *)otherContentBtn {
    if (_otherContentBtn == nil) {
        _otherContentBtn = [[UIButton alloc] init];
        // 设置文字颜色
        [_otherContentBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        // 不可交互
        _otherContentBtn.userInteractionEnabled = NO;
        // 内容可多行
        _otherContentBtn.titleLabel.numberOfLines = 0;
        
        UIImage *otherImage = [UIImage imageNamed:@"balloon_left_blue"];
        // 对图片周围保持不变，使用中间1px进行扩展填充
        otherImage = [otherImage resizableImageWithCapInsets:(UIEdgeInsetsMake(otherImage.size.height * 0.5 - 1, otherImage.size.width * 0.5 - 1, otherImage.size.height * 0.5, otherImage.size.width * 0.5))];
        [_otherContentBtn setBackgroundImage:otherImage forState:(UIControlStateNormal)];
        
    }
    return _otherContentBtn;
}

- (UIImageView *)myAvatarImageView {
    if (_myAvatarImageView == nil) {
        _myAvatarImageView = [[UIImageView alloc] init];
        _myAvatarImageView.contentMode = UIViewContentModeScaleToFill;
        
        _myAvatarImageView.image = [UIImage imageNamed:@"me"];
        _myAvatarImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _myAvatarImageView;
}

- (UIButton *)myContentBtn {
    if (_myContentBtn == nil) {
        _myContentBtn = [[UIButton alloc] init];
        [_myContentBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        _myContentBtn.userInteractionEnabled = NO;
        _myContentBtn.titleLabel.numberOfLines = 0;
    
        UIImage *myImage = [UIImage imageNamed:@"balloon_right_grey"];
        myImage = [myImage resizableImageWithCapInsets:(UIEdgeInsetsMake(myImage.size.height * 0.5 - 1, myImage.size.width * 0.5 - 1, myImage.size.height * 0.5, myImage.size.width * 0.5)) resizingMode:(UIImageResizingModeTile)];
        
        [_myContentBtn setBackgroundImage:myImage forState:(UIControlStateNormal)];
    }
    return _myContentBtn;
}

@end

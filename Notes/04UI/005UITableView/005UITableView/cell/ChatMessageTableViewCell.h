//
//  ChatMessageTableViewCell.h
//  005UITableView
//
//  Created by dfang on 2019-11-1.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatMessageModel;
#define CHATMESSAGEREUSECELLID @"chatMessageReusecellid"

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageTableViewCell : UITableViewCell

/** 聊天信息模型 */
@property (nonatomic, strong) ChatMessageModel *chatMessage;

/** 以传进来的tableView实例化cell */
+ (instancetype)cellWithTableView: (UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

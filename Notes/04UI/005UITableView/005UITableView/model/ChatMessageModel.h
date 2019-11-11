//
//  ChatMessageModel.h
//  005UITableView
//
//  Created by dfang on 2019-11-1.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 聊天消息类型(Me，Other) */
typedef NS_ENUM(NSUInteger, ChatMessageType) {
    ChatMessageOther = 0,
    ChatMessageMe = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageModel : NSObject

/** 消息内容 */
@property (nonatomic, copy) NSString *msg;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 是否隐藏时间(如果和前面消息时间相同就隐藏，否则就显示) */
@property (nonatomic, assign, getter=isHideTime) Boolean hideTime;
/** 消息类型(Me, Other) */
@property (nonatomic, assign) ChatMessageType type;
/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 字典实例化聊天消息模型对象 */
+ (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

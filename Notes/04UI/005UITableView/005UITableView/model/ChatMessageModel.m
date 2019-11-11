//
//  ChatMessageModel.m
//  005UITableView
//
//  Created by dfang on 2019-11-1.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ChatMessageModel.h"

@implementation ChatMessageModel

+ (instancetype)initWithDic:(NSDictionary *)dic {
    ChatMessageModel *chatMessage = [[ChatMessageModel alloc] init];
    [chatMessage setValuesForKeysWithDictionary:dic];
    return chatMessage;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"undefinedKey:%@, value:%@", key, value);
}

@end

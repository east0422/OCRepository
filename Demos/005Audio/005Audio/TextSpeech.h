//
//  TextSpeech.h
//  005Audio
//
//  Created by dfang on 2019-7-15.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextSpeech : NSObject

// 语音合成器
@property (nonatomic, strong, readonly) AVSpeechSynthesizer *synthesizer;

// 实例化类方法
+(instancetype)speech;

// 开始合成
- (void)beginConversation;

@end

NS_ASSUME_NONNULL_END

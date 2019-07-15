//
//  TextSpeech.m
//  005Audio
//
//  Created by dfang on 2019-7-15.
//  Copyright © 2019年 east. All rights reserved.
//

#import "TextSpeech.h"

@interface TextSpeech ()

// 语音设置器
@property (nonatomic, strong) NSArray *voices;
// 需要转化的文本
@property (nonatomic, strong) NSArray *strs;

@end

@implementation TextSpeech

+ (instancetype)speech {
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化语音合成器
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        // 初始化语音设置器
        _voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"],
                    [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"]];
        // 初始化文本
        _strs = @[@"Hello", @"你好", @"My name is lili", @"我不好", @"How are you!", @"很高兴认识你！"];
    }
    return self;
}

- (void)beginConversation {
    for (NSInteger i = 0 ; i < self.strs.count; i++) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.strs[i]];
        utterance.voice = self.voices[i%2];
        utterance.volume = 1.0;
        // 音速
        utterance.rate = 0.5;
        // 音调高低
        utterance.pitchMultiplier = 0.8;
        // 延迟
        utterance.postUtteranceDelay = 0.1;
        [self.synthesizer speakUtterance:utterance];
    }
}

@end

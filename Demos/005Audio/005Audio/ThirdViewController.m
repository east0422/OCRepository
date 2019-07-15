//
//  ThirdViewController.m
//  005Audio
//
//  Created by dfang on 2019-7-12.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ThirdViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface ThirdViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSString *audioPath;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"音频录制";
    
    AVAudioSession *recordSession = [AVAudioSession sharedInstance];
    [recordSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [recordSession setActive:YES error:nil];
    [recordSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    // 准备录音
    [self.audioRecorder prepareToRecord];
  
    // ipod touch5 可播放短wav(30s以内)
//     NSURL *url = [[NSBundle mainBundle] URLForResource:@"wonderful" withExtension:@"wav"];
//    SystemSoundID soundID;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
//    AudioServicesPlaySystemSound(soundID);
    
    // ipod touch5 可播放mp3
//     NSURL *url = [[NSBundle mainBundle] URLForResource:@"JingleBells" withExtension:@"mp3"];
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error:nil];
//    _audioPlayer.delegate = self;
//    [_audioPlayer play];
}

- (NSString *)audioPath {
    if (_audioPath == nil) {
        // 取出沙盒地址
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dirPath = [docPath stringByAppendingPathComponent:@"cusAudio"];
        // 若子目录没有就先创建子目录
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:dirPath]) { // 不存在就创建
            [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }

        // 获取当前时间以指定格式生成文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        NSString *curTimeStr = [formatter stringFromDate:[NSDate date]];

        _audioPath = [dirPath stringByAppendingFormat:@"/%@%@", curTimeStr, @".wav"];
//        _audioPath = [@"/Users/NewAdmin/Desktop/" stringByAppendingFormat:@"/%@%@", curTimeStr, @".caf"];
    }
    
    return _audioPath;
}

- (AVAudioRecorder *)audioRecorder {
    if (_audioRecorder == nil) {
        NSDictionary *settings = [[NSMutableDictionary alloc] init];
        // 设置录音格式
        [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        // 设置录音采样率(Hz), 影响音频的质量
        [settings setValue:[NSNumber numberWithFloat:11025] forKey:AVSampleRateKey];
         // 录音通道数 1 或 2
        [settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        // 录音的质量
        [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        // 内存组织方式大端还是小端
        [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        // 比特率
        [settings setValue:[NSNumber numberWithInt:16] forKey:AVEncoderBitRateKey];
        
        NSURL *fileUrl = [NSURL URLWithString:self.audioPath];
//        NSLog(@"fileUrl:%@", fileUrl);
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:settings error:nil];
        _audioRecorder.delegate = self;
        // 开启音量检测
        [_audioRecorder setMeteringEnabled:true];
    }
    return _audioRecorder;
}

- (IBAction)recordStart:(UIButton *)sender {
    if (!self.audioRecorder.isRecording) {
        [self.audioRecorder record];
    }
}

- (IBAction)recordPause:(UIButton *)sender {
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder pause];
    }
}

- (IBAction)recordStop:(UIButton *)sender {
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"error: %@", error);
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
//    NSLog(@"finish: %@, flag:%@", recorder.url, flag ? @"true" : @"no");
    
    // 录音完成自动播放, 局部变量没有声音
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
    _audioPlayer.delegate = self;
    [_audioPlayer play];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
//    NSLog(@"player: %@, error:%@", player, error);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//    NSLog(@"finish playing flag:%@", flag ? @"yes" : @"no");
}

@end

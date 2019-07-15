//
//  FirstViewController.m
//  005Audio
//
//  Created by dfang on 2019-7-12.
//  Copyright © 2019年 east. All rights reserved.
//

#import "FirstViewController.h"
#import <AudioToolbox/AudioToolbox.h>

void completionCallback(SystemSoundID sid, void *clientData) {
    AudioServicesPlaySystemSound(sid);
}

@interface FirstViewController ()

@property (nonatomic, assign) Boolean isPlaying;

@end

SystemSoundID soundID;
@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"短音频";
    
    self.isPlaying = false;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"wonderful" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
}

- (IBAction)play:(UIButton *)sender {
    if (self.isPlaying) {
        return;
    }
    self.isPlaying = true;
    // 设置播放完成事件
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, (void *)completionCallback, NULL);
    
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 震动
    // 播放短音效
    AudioServicesPlaySystemSound(soundID);
    // 声音并震动（ipod touch不支持震动）
//    AudioServicesPlayAlertSound(soundID);
}

- (IBAction)stopCycle:(id)sender {
    // Disposes of a system sound object and associated resources
//    AudioServicesDisposeSystemSoundID(soundID);
    
    AudioServicesRemoveSystemSoundCompletion(soundID);
    self.isPlaying = false;
}

@end

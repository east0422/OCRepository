//
//  SecondViewController.m
//  005Audio
//
//  Created by dfang on 2019-7-12.
//  Copyright © 2019年 east. All rights reserved.
//

#import "SecondViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SecondViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"播放音乐";
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"JingleBells" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    // 允许更改音速
    self.player.enableRate = true;
    self.player.rate = 0.5;
}

- (IBAction)play:(id)sender {
    [self.player play];
}

- (IBAction)pause:(id)sender {
    [self.player pause];
}

- (IBAction)stop:(id)sender {
    // The stop method does not reset the value of the currentTime property to 0. In other words, if you call stop during playback and then call play, playback resumes at the point where it left off.
    self.player.currentTime = 0;
    [self.player stop];
}

- (IBAction)forward:(id)sender {
    self.player.currentTime += 5;
}

- (IBAction)back:(id)sender {
    self.player.currentTime -= 5;
}

- (IBAction)rateChanged:(UISlider *)sender {
    // 0.5 ~ 2
    self.player.rate = sender.value;
}

- (IBAction)voiceChanged:(UISlider *)sender {
    self.player.volume = sender.value;
}

@end

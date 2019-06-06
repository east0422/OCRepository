//
//  IntegrationAnimationVC.m
//  01Animation
//
//  Created by dfang on 2019-6-5.
//  Copyright © 2019年 east. All rights reserved.
//

#import "IntegrationAnimationVC.h"
#import <DCPathButton/DCPathButton.h>
#import <DWBubbleMenuButton/DWBubbleMenuButton.h>
#import <MCFireworksButton/MCFireworksButton.h>

@interface IntegrationAnimationVC () <DCPathButtonDelegate>

// 动画子按钮弹出
@property (nonatomic, strong) DCPathButton *pathAnimationView;
// 冒泡子按钮
@property (nonatomic, strong) DWBubbleMenuButton *bubbleAnimationView;
// 粒子点赞效果按钮
@property (nonatomic, strong) MCFireworksButton *fireworksAnimationView;
// 粒子点赞按钮是否被选
@property (nonatomic, assign) BOOL selected;

@end

@implementation IntegrationAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selected = NO;
    [self.view addSubview:self.pathAnimationView];
    [self.view addSubview:self.bubbleAnimationView];
    [self.view addSubview:self.fireworksAnimationView];
    
    [self pathAnimation];
}

- (DCPathButton *)pathAnimationView {
    if (!_pathAnimationView) {
        _pathAnimationView = [[DCPathButton alloc] initWithButtonFrame:CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2, 50, 50) centerImage:[UIImage imageNamed:@"chooser-button-tab"] highlightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
        // 声音
        _pathAnimationView.allowSounds = YES;
        // 旋转加号变为❎号
        _pathAnimationView.allowCenterButtonRotation = YES;
        _pathAnimationView.delegate = self; // 可设置代理监听代理事件
        
        DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
                                                               highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
                                                                backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                     backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
        
        [_pathAnimationView addPathItems: @[itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5]];
    }
    return _pathAnimationView;
}

- (DWBubbleMenuButton *)bubbleAnimationView {
    if (!_bubbleAnimationView) {
        UILabel *homeLabel = [self createHomeButtonView];
        
        _bubbleAnimationView = [[DWBubbleMenuButton alloc] initWithFrame: CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT-200, 50, 50) expansionDirection:DirectionUp];
        _bubbleAnimationView.homeButtonView = homeLabel;
        [_bubbleAnimationView addButtons:[self createDemoButtonArray]];
    }
    return _bubbleAnimationView;
}

- (MCFireworksButton *)fireworksAnimationView {
    if (!_fireworksAnimationView) {
        _fireworksAnimationView = [[MCFireworksButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-25, 50, 50)];
        _fireworksAnimationView.particleImage = [UIImage imageNamed:@"Sparkle"];
        _fireworksAnimationView.particleScale = 0.05;
        _fireworksAnimationView.particleScaleRange = 0.02;
        [_fireworksAnimationView setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
        
        [_fireworksAnimationView addTarget:self action:@selector(functionOfMCFireworksButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fireworksAnimationView;
}

// overrider
- (NSString *)controllerTitle {
    return @"综合案例";
}

- (NSArray *)btnTitlesAndSelectors {
    return @[@{@"title": @"子按钮", @"selector": @"pathAnimation"},
             @{@"title": @"冒泡按钮", @"selector": @"bubbleAnimation"},
             @{@"title": @"粒子点赞", @"selector": @"fireworksAnimation"},
             ];
}

#pragma mark - 子按钮弹出
- (void)pathAnimation {
    self.fireworksAnimationView.hidden = YES;
    self.bubbleAnimationView.hidden = YES;
    self.pathAnimationView.hidden = NO;
}

#pragma mark - 冒泡按钮
- (void)bubbleAnimation {
    self.pathAnimationView.hidden = YES;
    self.fireworksAnimationView.hidden = YES;
    self.bubbleAnimationView.hidden = NO;
}

- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2;
    label.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    label.clipsToBounds = YES;
    
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"A", @"B", @"C", @"D", @"E", @"F"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

#pragma mark - 粒子点赞
- (void)fireworksAnimation {
    self.pathAnimationView.hidden = YES;
    self.bubbleAnimationView.hidden = YES;
    self.fireworksAnimationView.hidden = NO;
}

- (void)functionOfMCFireworksButton:(UIButton *)sender {
    self.selected = !self.selected;
    if (self.selected) {
        [self.fireworksAnimationView popOutsideWithDuration:0.5];
        [self.fireworksAnimationView setImage:[UIImage imageNamed:@"Like-Blue"] forState:UIControlStateNormal];
        [self.fireworksAnimationView animate];
    } else {
        [self.fireworksAnimationView popInsideWithDuration:0.4];
        [self.fireworksAnimationView setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
    }
}

// DCPathButtonDelegate method
- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@"tapped %lu", (unsigned long)itemButtonIndex);
}

@end

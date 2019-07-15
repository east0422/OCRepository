//
//  FourthViewController.m
//  005Audio
//
//  Created by dfang on 2019-7-12.
//  Copyright © 2019年 east. All rights reserved.
//

#import "FourthViewController.h"
#import "TextSpeech.h"
#import <AVFoundation/AVFoundation.h>

@interface FourthViewController () <AVSpeechSynthesizerDelegate>

// 消息数组
@property (nonatomic, strong) NSMutableArray *list;
// 语音合成
@property (nonatomic, strong) TextSpeech *speech;

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"文本转语音";
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f);
    self.tableView.allowsSelection = NO;
    
    _list = [NSMutableArray array];
    _speech = [TextSpeech speech];
    _speech.synthesizer.delegate = self;
    [_speech beginConversation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.row % 2 == 0 ? @"cell1" : @"cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        if (indexPath.row % 2 == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = UIColor.greenColor;
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.backgroundColor = UIColor.whiteColor;
        }
    }
    cell.textLabel.text = self.list[indexPath.row];
    
    return cell;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    [self.list addObject:utterance.speechString];
    // 刷新数据
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.list.count - 1 inSection:0];
    [self.tableView reloadData];
    
    // 滚动到最后一个单元格
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end

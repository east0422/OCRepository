//
//  ChatVewController.m
//  005UITableView
//
//  Created by dfang on 2019-11-1.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ChatVewController.h"
#import "ChatMessageModel.h"
#import "ChatMessageTableViewCell.h"
#import "Masonry.h"
#import "EmoticModel.h"
#import "NSDate+Formatter.h"

#define CUSTOMKEYBOARDHEIGHT 254

/** 底部面板类型 */
typedef NS_ENUM(NSUInteger, MESSAGETYPE) {
    MESSAGEVOICE = 1000,   // 语音
    MESSAGETEXT = 1001,    // 文本
    MESSAGEEMOTIC = 1002,  // 表情
    MESSAGEFILE = 1003,    // 文件
};

@interface ChatVewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    Boolean isCalculated; // 默认为false,只作为标记在estimatedHeightForRowAtIndexPath中标记是否调用过cellForRowAtIndexPath
}

/** 消息数组 */
@property (nonatomic, strong) NSMutableArray *messages;
/** 标签图标数组 */
@property (nonatomic, strong) NSArray *emotics;

/** 表视图 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 底部视图 */
@property (weak, nonatomic) IBOutlet UIView *footerView;
/** 文本框输入内容 */
@property (weak, nonatomic) IBOutlet UITextField *textField;
/** 表情面板视图 */
@property (weak, nonatomic) IBOutlet UIView *emoticView;

/** 布局约束 */
/** 底部footerView距离view视图底部距离约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewBottomConstraint;

/** 发送消息类型 */
@property (nonatomic, assign) MESSAGETYPE msgType;

@end

@implementation ChatVewController

/** 懒加载消息数组 */
- (NSMutableArray *)messages {
    if (_messages == nil) {
        NSString *fileStr = [[NSBundle mainBundle] pathForResource:@"chatmessages" ofType:@"plist"];
        NSArray *dicArrs = [NSArray arrayWithContentsOfFile:fileStr];
        NSMutableArray *chatMessages = [NSMutableArray array];
        ChatMessageModel *lastMessage = nil;
        for (NSDictionary *dic in dicArrs) {
            ChatMessageModel *message = [ChatMessageModel initWithDic:dic];
            message.hideTime = [lastMessage.time isEqualToString:message.time];
            [chatMessages addObject:message];
            lastMessage = message;
        }
        _messages = chatMessages;
    }
    return _messages;
}

/** 表情数组 */
- (NSArray *)emotics {
    if (_emotics == nil) {
        NSString *fileStr = [[NSBundle mainBundle] pathForResource:@"emotics" ofType:@"plist"];
        NSArray *dicArrs = [NSArray arrayWithContentsOfFile:fileStr];
        NSMutableArray *emotics = [NSMutableArray array];
        for (NSDictionary *dic in dicArrs) {
            EmoticModel *emoticModel = [EmoticModel initWithDic:dic];
            [emotics addObject:emoticModel];
        }
        _emotics = emotics;
    }
    return _emotics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置背景色，若子视图要使用该背景色则需将子视图设置为透明
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:239/255.0 blue:213/255.0 alpha:1.0];
    
//    // 高度估算值
//    self.tableView.estimatedRowHeight = 100;
    // 注册cell
    [self.tableView registerClass:ChatMessageTableViewCell.class forCellReuseIdentifier:CHATMESSAGEREUSECELLID];
    
    // 用于占位
    UIView *leftView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 20, 0))];
    leftView.backgroundColor = UIColor.clearColor;
    self.textField.leftView = leftView;
    // 总是出现
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    // 监听键盘显示
    [self listenKeyboardNotifiction];
    
    [self addEmotics];
}

/** 移除通知 (iOS8.4以后苹果做了优化会在该函数中删除通知；但iOS8.4以前没有) */
- (void)dealloc {
    // iOS8.4以后苹果做了优化，做了该操作，可不需要再额外添加；但iOS8.4以前必须要
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 添加表情 */
- (void)addEmotics {
    // 立即刷新，不然emoticView的width值会是storyboard中最后选中对应设备设置值
    [self.view layoutIfNeeded];
    
    NSInteger colum = 4; // 每行表情个数
    CGFloat width = 40; // 表情宽度
    CGFloat height = 40; // 表情高度
    CGFloat paddingH = (self.emoticView.bounds.size.width - width * colum) / (colum + 1); // 水平间距
    CGFloat paddingV = 10; // 垂直间距
//    NSLog(@"%@----%@---%@", NSStringFromCGRect(self.emoticView.bounds), NSStringFromCGRect(self.view.bounds), NSStringFromCGRect([UIScreen mainScreen].bounds));
    for (int i = 0; i < self.emotics.count; i++) {
        // 在autolayout中使用frame会有一些意想不到的布局问题
        CGRect frame = CGRectMake(paddingH + (i%colum) * (width + paddingH), paddingV + (i / colum) * (height + paddingV), width, height);
        UIButton *emoBtn = [[UIButton alloc] initWithFrame:frame];
        
//        UIButton *emoBtn = [[UIButton alloc] init];
    
        emoBtn.tag = i;
        
        EmoticModel *emoticModel = self.emotics[i];
        [emoBtn setBackgroundImage:[UIImage imageNamed:emoticModel.icon] forState:(UIControlStateNormal)];
        [emoBtn addTarget:self action:@selector(emoticItemClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.emoticView addSubview:emoBtn];
        
        // 使用masonry框架布局，需要先加到父视图中(默认参照是父视图)
//        [emoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(width);
//            make.height.mas_equalTo(height);
//            make.left.mas_offset(paddingH + (i%colum) * (width + paddingH));
//            make.top.mas_offset(paddingV + (i / colum) * (height + paddingV));
//        }];
    }
}

/** 点击单个表情 */
- (void)emoticItemClicked:(UIButton *)emoItemBtn {
    EmoticModel *emoticModel = self.emotics[emoItemBtn.tag];
    self.textField.text = [self.textField.text stringByAppendingFormat:@"[%@]", emoticModel.desc];
}

#pragma mark -- IBACTION
/** 语音按钮，发送语音 */
- (IBAction)voiceClicked:(UIButton *)sender {
    [self btnClickedWithMessageType:(MESSAGEVOICE) andBottomValue:0];
}

/** 点击表情面板按钮 */
- (IBAction)emoticClicked:(UIButton *)sender {
    [self btnClickedWithMessageType:(MESSAGEEMOTIC) andBottomValue:-CUSTOMKEYBOARDHEIGHT];
}

/** 文件按钮 */
- (IBAction)fileClicked:(UIButton *)sender {
    [self btnClickedWithMessageType:(MESSAGEFILE) andBottomValue:-CUSTOMKEYBOARDHEIGHT];
}

/** 按钮点击类型及底部距离约束值 */
- (void)btnClickedWithMessageType:(MESSAGETYPE)messageType andBottomValue:(CGFloat)bottom {
    if (self.msgType == MESSAGETEXT) {
        self.msgType = messageType;
        [self.view endEditing:YES];
    } else if (self.msgType == messageType) {
        self.msgType = MESSAGETEXT;
        [self.textField becomeFirstResponder];
    } else {
        self.msgType = messageType;
        self.footerViewBottomConstraint.constant = bottom;
        [self.view layoutIfNeeded];
    }
}

#pragma mark - custom method
// 监听键盘通知
- (void)listenKeyboardNotifiction {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/** 处理键盘frame即将改变通知 */
- (void)keyboardFrameWillChange:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;

    CGFloat oldBottom = self.footerViewBottomConstraint.constant;
    CGFloat newBottom = 0;
    switch (self.msgType) {
        case MESSAGEVOICE:
            newBottom = 0;
            break;
        case MESSAGEEMOTIC:
        case MESSAGEFILE:
            newBottom = -CUSTOMKEYBOARDHEIGHT;   // 和storyboard中设置保持一致
            break;
        case MESSAGETEXT:
        default:
        {
            // 默认msgType未赋值为0，触发键盘后赋值为MESSAGETEXT
            self.msgType = MESSAGETEXT;
            CGRect kbBounds = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            newBottom = kbBounds.origin.y - self.view.bounds.size.height;
        }
            break;
    }
    if (newBottom != oldBottom) { // 相等的话不做操作
        self.footerViewBottomConstraint.constant = newBottom;
        // 添加动画整体一起上移
        CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

// 处理键盘通知事件
- (void)showKeyboard:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    CGRect kbBounds = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.footerViewBottomConstraint.constant = -kbBounds.size.height;
    
    // 添加动画整体一起上移
    CGFloat duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

/** 隐藏键盘 */
- (void)hideKeyboard {
    // 丢弃输入框第一响应者
//    [self.textField resignFirstResponder];
    // 文本框结束编辑
    [self.textField endEditing:YES];
    // view的所有内部文本输入框都结束编辑
    [self.view endEditing:YES];
    self.footerViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/** 隐藏footerview下面表情面板等视图 */
- (void)hideAllBelowFooterView {
    // 收缩键盘
    [self.view endEditing:YES];
    
    self.footerViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark --- tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatMessageTableViewCell *cell = [ChatMessageTableViewCell cellWithTableView:tableView];
    cell.chatMessage = self.messages[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 只要有该方法无论内部有无执行体，tableview向左或右滑动都会在右侧出现删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) { // 非删除，返回
        return;
    }
    if (indexPath.row < self.messages.count - 1) { // 不是最后一个
        ChatMessageModel *delMsg = self.messages[indexPath.row];
        ChatMessageModel *nextMsg = self.messages[indexPath.row + 1]; // 要删除的后一条数据
        if (!delMsg.isHideTime && nextMsg.isHideTime) { // 删除的数据时间显示，后一条数据时间是隐藏的，后一条数据需要更改
            nextMsg.hideTime = NO;
            // 先删除
            [self.messages removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
//            // 后更新
            [self.messages replaceObjectAtIndex:indexPath.row withObject:nextMsg];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            return;
        }
    }
    // 删除数据源中对应数据
    [self.messages removeObjectAtIndex:indexPath.row];
    // 表视图删除对应cell
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
}

#pragma mark --- tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMessageModel *message = self.messages[indexPath.row];
    return message.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isCalculated) { // 调用cellForRowAtIndexPath是为了计算cellHeight，计算过就不用再计算
        [self tableView:tableView cellForRowAtIndexPath:indexPath];
        isCalculated = YES;
    }
    ChatMessageModel *message = self.messages[indexPath.row];
    return message.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideAllBelowFooterView];
}

#pragma mark --- scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideAllBelowFooterView];
}

#pragma mark --- textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    ChatMessageModel *chatMsg = [[ChatMessageModel alloc] init];
    chatMsg.msg = textField.text;
    chatMsg.hideTime = YES;
    chatMsg.type = (arc4random() % 2 == 1 ? ChatMessageMe : ChatMessageOther);
    
    [self.messages addObject:chatMsg];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
    
    // 打印高度为0.000000
//    ChatMessageModel *last1 = self.messages[indexPath.row];
//    NSLog(@"last1 height: %f", last1.cellHeight);
    // 手动调用cellForRowAtIndexPath创建cell计算cell高度
    [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
     // 打印高度为实际计算后的值
//    ChatMessageModel *last2 = self.messages[indexPath.row];
//    NSLog(@"last2 height: %f", last2.cellHeight);
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationBottom)];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    
    // 清空文本框
    self.textField.text = @"";
    
    return YES;
}

@end

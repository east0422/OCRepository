//
//  ChatMessageTableView.m
//  005UITableView
//
//  Created by dfang on 2019-11-8.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ChatMessageTableView.h"

@implementation ChatMessageTableView

// 重新布局滑动右侧删除按钮样式, 遍历所有cell比较消耗性能，需要优化
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // iOS11版本以上,自定义删除按钮高度方法:
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if (version.doubleValue >= 11.0) {
        UIView *delView = nil;
        if ([[self.subviews lastObject] isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) { // 通常最后一个就是
            delView = [self.subviews lastObject];
        } else {
            for (UIView *subview in self.subviews) {
                if([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
                {
                    delView = subview;
                    break;
                }
            }
        }
        if (delView == nil) { // 未找到
            return;
        }
        // 修改背景圆角
        delView.layer.cornerRadius = 5.f;
        delView.layer.masksToBounds = YES;
        
        CGRect originFrame = delView.frame;
//        NSLog(@"frame:%@", NSStringFromCGRect(originFrame));
        CGRect newFrame = originFrame;
        newFrame.size.height = 40;
        newFrame.origin.y = originFrame.origin.y + (originFrame.size.height - 40)/2;
        delView.frame = newFrame;
    }
}

@end

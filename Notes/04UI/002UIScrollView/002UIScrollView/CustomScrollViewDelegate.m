//
//  CustomScrollViewDelegate.m
//  002UIScrollView
//
//  Created by dfang on 2019-10-9.
//  Copyright © 2019年 east. All rights reserved.
//

#import "CustomScrollViewDelegate.h"

@implementation CustomScrollViewDelegate

#pragma mark --- scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollview滚动了！");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollview即将开始拖动！");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollview停止拖动！");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollview滚动即将开始惯性减速！");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollview滚动惯性减速结束！");
}

@end

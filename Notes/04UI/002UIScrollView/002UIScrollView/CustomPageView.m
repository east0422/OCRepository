//
//  CustomPageView.m
//  002UIScrollView
//
//  Created by dfang on 2019-10-10.
//  Copyright © 2019年 east. All rights reserved.
//

#import "CustomPageView.h"

@interface CustomPageView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) NSTimer *timer; // 定时器

@end

@implementation CustomPageView

+ (instancetype)loadFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (instancetype)pageView {
    return [self loadFromXib];
}

// 调用init和initWithFrame都会调用（通过代码创建）
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [CustomPageView pageView];
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

// frame有改变时
- (void)layoutSubviews {
    [super layoutSubviews];
    // 一次运行循环runloop结束提交所有ui更改渲染才会进入这里
    NSLog(@"%s, %@", __func__, NSStringFromCGRect(self.frame));
    
    self.scrollView.frame = self.bounds;
    CGFloat W = self.scrollView.bounds.size.width;
    CGFloat H = self.scrollView.bounds.size.height;
    NSInteger index = 0;
    for (UIView *subView in self.scrollView.subviews) {
        subView.frame = CGRectMake(index * W, 0, W, H);
        index++;
    }
    self.scrollView.contentSize = CGSizeMake(index * W, 0);
    
    CGSize pageControlSize = self.pageControl.frame.size;
    self.pageControl.frame = CGRectMake(self.bounds.size.width - pageControlSize.width - 20, self.bounds.size.height - pageControlSize.height, pageControlSize.width, pageControlSize.height);
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    [self stopTimer];
    [self startTimer];
}

- (void)setImageNames:(NSArray *)imageNames {
    _imageNames = imageNames;
    
    [self removeScrollViewSubViews];
   
    // 添加新的视图
    CGFloat W = self.scrollView.bounds.size.width;
    CGFloat H = self.scrollView.bounds.size.height;
    for (int i = 0; i < imageNames.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(W * i, 0, W, H)];
        imageView.image = [UIImage imageNamed:imageNames[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.scrollView addSubview:imageView];
    }
    // 设置滚动区域
    self.scrollView.contentSize = CGSizeMake(W * imageNames.count, 0);
    // 开启分页模式，分页是按照scrollview的宽度来滚动的(而不是依照image大小，它根本不知道image大小)
    self.scrollView.pagingEnabled = YES;
    
    // pageControl在只有一个图片视图时隐藏
    self.pageControl.hidesForSinglePage = YES;
    // pageControl指示器点个数
    self.pageControl.numberOfPages = imageNames.count;
    
    [self startTimer];
}

// 删除scrollview所有的子视图
- (void)removeScrollViewSubViews {
    // note: scrollView的subviews是否包含滚动条视图依据滚动条是否显示
    
    // 删除子视图后subviews会重新计算，这样不会删除所有子视图，可以使用--或其他方式
    //    for (int i = 0; i < self.scrollView.subviews.count; i++) {
    //        [self.scrollView.subviews[i] removeFromSuperview];
    //    }
    
    // for...in语句
//    for (UIView *view in self.scrollView.subviews) {
//        [view removeFromSuperview];
//    }
    
    // 让每个子视图执行方法
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setPageCurColor:(UIColor *)pageCurColor {
    _pageCurColor = pageCurColor;
    self.pageControl.currentPageIndicatorTintColor = pageCurColor;
}

- (void)setPageTintColor:(UIColor *)pageTintColor {
    _pageTintColor = pageTintColor;
    self.pageControl.pageIndicatorTintColor = pageTintColor;
}

#pragma mark --- scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = (scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5);
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

// 开启定时器
- (void)startTimer {
    if (self.imageNames.count <= 1) {
        return;
    }
    NSTimeInterval interval = self.timeInterval;
    if (interval == 0) {
        interval = 1;
    }
    // 使用timerWithTimeInterval方法timer需要为强引用且需要加入到runloop对应的mode中，否则不会触发timerHandle
//    self.timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // scheduledTimerWithTimeInterval方法系统内部会自动强引用而且会放入defaultmode中
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
    // 添加到runloop模式中，使得ui更新时不会阻塞timeHandle(可以尝试去除滚动视图代理方法中拖动的监听再看下述代码加否的区别)
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 崩溃
//    NSThread *thread = [[NSThread alloc] initWithBlock:^{
//        // 不会触发timerHandle
//        self.timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
////        [self.timer fire];
//        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//        [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
//        [runloop run];
//    }];
//    [thread start];
}

// 停止定时器
- (void)stopTimer {
    [self.timer invalidate];
}

// 定时器响应函数
- (void)timerHandle {
    NSLog(@"%s", __func__);
    NSInteger newCurPage = self.pageControl.currentPage + 1;
    if (newCurPage == self.imageNames.count) { // 最后一个
        newCurPage = 0;
    }
    // 更改当前pageControl指示器，scrollView的contentOffset变化会触发scrollViewDidScroll而进行指示器的修改
//    self.pageControl.currentPage = newCurPage;
    
    // 设置scrollview偏移量
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = newCurPage * self.scrollView.frame.size.width;
//    self.scrollView.contentOffset = offset;
    
    [self.scrollView setContentOffset:offset animated:YES];
}

@end

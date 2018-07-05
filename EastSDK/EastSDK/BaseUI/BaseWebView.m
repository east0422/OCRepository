//
//  BaseWebView.m
//  EastSDK
//
//  Created by dfang on 2018-7-5.
//  Copyright © 2018年 east. All rights reserved.
//

#import "BaseWebView.h"
#import "Constants.h"

@interface BaseWebView () <UIWebViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation BaseWebView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialization code
    }
    return self;
}

// 懒加载指示器视图
- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.backgroundColor = rgbaColor(0, 0, 0, 0.8);
        _indicatorView.layer.borderWidth = 1;
        _indicatorView.layer.cornerRadius = 6;
        
        [self addSubview:_indicatorView];
    }
    
    [self bringSubviewToFront:_indicatorView];
    return _indicatorView;
}

// 显示指示器视图
- (void)showIndicatorView {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize frameSize = self.frame.size;
        self.indicatorView.frame = CGRectMake((frameSize.width - 60 )/2, (frameSize.height - 60)/2, 60, 60);
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
    });
}

// 隐藏指示器视图
- (void)hideIndicatorView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.indicatorView.hidden = YES;
        [self.indicatorView stopAnimating];
    });
}

- (void)setNativeInteractionEnabled:(BOOL)nativeInteractionEnabled {
    _nativeInteractionEnabled = nativeInteractionEnabled;
    self.delegate = self;
}

- (void)setShowIndicatorWhenLoading:(BOOL)showIndicatorWhenLoading {
    _showIndicatorWhenLoading = showIndicatorWhenLoading;
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.showIndicatorWhenLoading) {
        [self showIndicatorWhenLoading];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.showIndicatorWhenLoading) {
        [self hideIndicatorView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.showIndicatorWhenLoading) {
        [self hideIndicatorView];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end

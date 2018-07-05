//
//  BaseWebView.h
//  EastSDK
//
//  Created by dfang on 2018-7-5.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWebView : UIWebView

// 加载时是否显示指示器视图
@property (nonatomic, assign) BOOL showIndicatorWhenLoading;

// 是否允许与原生交互
@property (nonatomic, assign) BOOL nativeInteractionEnabled;

@end

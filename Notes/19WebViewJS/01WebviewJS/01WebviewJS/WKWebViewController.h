//
//  WKWebViewController.h
//  01WebviewJS
//
//  Created by dfang on 2020-5-26.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END

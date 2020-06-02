//
//  WKMessageHandler.h
//  01WebviewJS
//
//  Created by dfang on 2020-5-26.
//  Copyright © 2020 east. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKMessageHandler : NSObject <WKScriptMessageHandler, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// 回掉js方法时需要用到webView
@property (nonatomic, strong) WKWebView *webView;

- (instancetype)initWithWebView:(WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END

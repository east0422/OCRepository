//
//  JSCoreMessageHandler.h
//  01WebviewJS
//
//  Created by dfang on 2020-5-27.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CallBack)(NSString *base64);

@protocol JSCoreMessageHanderProtocol <JSExport>

@property (nonatomic, strong) CallBack callback;

- (void)test;

- (void)choosePicFromAlbum:(CallBack)callback;

@end

@interface JSCoreMessageHandler : NSObject <JSCoreMessageHanderProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** documentView.webView.mainFrame.javaScripeContext只针对UIWebView */
- (void)addHanderForWebView:(UIWebView *)webView;

/** 不在JSCoreMessageHanderProtocol中，对js代码不可见(js代码只能访问JSCoreMessageHanderProtocol中方法和属性变量) */
- (void)evaluteJSStr;

@end

NS_ASSUME_NONNULL_END

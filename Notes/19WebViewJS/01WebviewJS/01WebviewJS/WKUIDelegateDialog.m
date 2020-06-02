//
//  WKUIDelegateDialog.m
//  01WebviewJS
//
//  Created by dfang on 2020-5-26.
//  Copyright © 2020 east. All rights reserved.
//

#import "WKUIDelegateDialog.h"
#import "Utils.h"

@implementation WKUIDelegateDialog

// 获取rootViewController进行跳转
- (void)presentToVC:(UIViewController *)vc animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    [[Utils rootVC] presentViewController:vc animated:animated completion:completion];
}

#pragma --- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert框" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler: ^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:okAction];
    
    [self presentToVC:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"Confirm框" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [confirm addAction:okAction];
    [confirm addAction:cancelAction];
    
    [self presentToVC:confirm animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *promptController = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:(UIAlertControllerStyleAlert)];
    [promptController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(promptController.textFields.lastObject.text);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(@"取消了");
    }];
    [promptController addAction:okAction];
    [promptController addAction:cancelAction];
    
    [self presentToVC:promptController animated:YES completion:nil];
}


@end

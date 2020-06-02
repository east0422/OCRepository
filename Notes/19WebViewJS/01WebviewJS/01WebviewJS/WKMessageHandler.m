//
//  WKMessageHandler.m
//  01WebviewJS
//
//  Created by dfang on 2020-5-26.
//  Copyright © 2020 east. All rights reserved.
//

#import "WKMessageHandler.h"
#import "Utils.h"
#import "WKWebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface WKMessageHandler () {
    NSString *callbackName;
}

@end

@implementation WKMessageHandler

- (instancetype)initWithWebView:(WKWebView *)webView {
    self = [super init];
    if (self) {
        self.webView = webView;
    }
    return self;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name isEqualToString:@"call"]) {
//        NSLog(@"body:%@", message.body);
        NSString *bodyStr = [NSString stringWithFormat:@"%@", message.body];
        if (bodyStr && bodyStr.length > 0) {
            id jsonData = [NSJSONSerialization JSONObjectWithData:[bodyStr dataUsingEncoding:(NSUTF8StringEncoding)] options:(NSJSONReadingFragmentsAllowed) error:nil];
            if (jsonData && [jsonData isKindOfClass:[NSDictionary class]] ) {
                [self handleWebViewSendMessageWithDictionary:jsonData];
            }
        }
       
    }
}

- (void)handleWebViewSendMessageWithDictionary:(NSDictionary *)jsonDict {
    NSString *name = jsonDict[@"name"];
    if (!name || name.length < 1) {
        return;
    }
    id paramData = jsonDict[@"params"];
    callbackName = jsonDict[@"callback"];
    
    if (!paramData || ![paramData isKindOfClass:[NSDictionary class]]) {
        [Utils showMessage:@"请检查一下js端参数"];
        return;
    }
    
    if ([name isEqualToString:@"WebViewOpen"]) { // 打开新网页
        [self handleWebViewOpen:paramData];
    } else if ([name isEqualToString:@"WebViewClose"]) { // 关闭name标记已经打开的网页
        [self handleWebViewClose:paramData];
    } else if ([name isEqualToString:@"CameraOpen"]) {
        [self handleCamerOpen];
    } else if ([name isEqualToString:@"AlbumOpen"]) {
        [self handleAlbumOpen];
    } else if ([name isEqualToString:@"ToastShow"]) {
        [self handleToastShow:paramData];
    } else if ([name isEqualToString:@"DataSave"]) {
        [self handleDataSave:paramData];
    } else if ([name isEqualToString:@"DataGet"]) {
        [self handleDataGet:paramData];
    } else if ([name isEqualToString:@"CallPhone"]) {
        [self handleCallPhone:paramData];
    }
}

- (void)handleWebViewOpen:(NSDictionary *)paramDict {
    NSString *webName = paramDict[@"name"];
    NSString *urlStr = paramDict[@"url"];
    
    WKWebViewController *webViewController = [[WKWebViewController alloc] init];
    webViewController.urlStr = urlStr;
    webViewController.name = webName;
    
    if ([Utils navVC] != nil) {
        [[Utils navVC] pushViewController:webViewController animated:YES];
    } else {
        [[Utils rootVC] presentViewController:webViewController animated:YES completion:nil];
    }
}

- (void)handleWebViewClose:(NSDictionary *)paramDict {
    NSString *webName = paramDict[@"name"];
    if (webName && webName.length > 0) {
        WKWebViewController *tempWebViewController = nil;
        if ([Utils navVC] != nil) {
            NSArray *navChildViewControllers = [Utils navVC].childViewControllers;
            for (WKWebViewController *webViewController in navChildViewControllers) {
                if ([webViewController.name isEqualToString:webName]) {
                    NSInteger thisIndex = [navChildViewControllers indexOfObject:webViewController];
                    thisIndex -= 1;
                    if (thisIndex < 0) {
                        thisIndex = 0;
                    }
                    tempWebViewController = navChildViewControllers[thisIndex];
                    break;
                }
            }
        } else {
            UIViewController *presentingVC = [Utils rootVC].presentedViewController;
            if ([presentingVC isKindOfClass:[WKWebViewController class]] && [((WKWebViewController *)presentingVC).name isEqualToString:webName]) {
                tempWebViewController = (WKWebViewController *)presentingVC;
            }
        }
        
        if (tempWebViewController != nil) {
            if ([Utils navVC] != nil) {
                [[Utils navVC] popToViewController:tempWebViewController animated:YES];
            } else {
                [tempWebViewController dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [self.webView goBack];
        }
    }
}

- (void)handleCamerOpen {
    // 相机功能
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [Utils showMessage:@"该设备不支持相机功能"];
        return;
    }
    
    NSDictionary * mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
    
    // 是否授权使用相机
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        NSString * title = [NSString stringWithFormat:@"%@没有权限访问相机", appName];
        NSString * message = [NSString stringWithFormat:@"请进入系统 设置>隐私>相机 允许\"%@\"访问您的相机",appName];
        [Utils showAlertWithTitle:title andMessage:message];
        return;
    }
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerImage.delegate = self;
    
    [[Utils rootVC] presentViewController:pickerImage animated:YES completion:nil];
}

- (void)handleAlbumOpen {
    // 是否支持相册功能
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [Utils showMessage:@"该设备不支持相册功能"];
        return;
    }
    
    // 应用名称, 提示信息里会用到
    NSDictionary * mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
    
    // 是否授权访问照片
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusDenied) {
        NSString * title = [NSString stringWithFormat:@"%@没有权限访问照片", appName];
        NSString * message = [NSString stringWithFormat:@"请进入系统 设置>隐私>照片 允许\"%@\"访问您的照片",appName];
        [Utils showAlertWithTitle:title andMessage:message];
        return;
    }
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    
    [[Utils rootVC] presentViewController:pickerImage animated:YES completion:nil];
}

- (void)handleToastShow:(NSDictionary *)paramDict {
    NSString *message = paramDict[@"name"];
    if (!message || message.length < 1) {
        [Utils showMessage:@"请在左侧输入框输入文本"];
        return;
    }
    [Utils showMessage:message];

    if (callbackName && callbackName.length > 0) {
        NSString *callbackStr = [NSString stringWithFormat:@"%@('success')", callbackName];
        [self.webView evaluateJavaScript:callbackStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//            NSLog(@"-- %@  %@", obj, error);
            self->callbackName = nil;
        }];
    }
}

- (void)handleDataSave:(NSDictionary *)paramDict {
    NSString *name = paramDict[@"name"];
    NSString *value = paramDict[@"value"];
    if (name && name.length > 0 && value != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Utils showMessage:@"数据保存成功"];

        if (callbackName && callbackName.length > 0) {
            NSString *callbackStr = [NSString stringWithFormat:@"%@('success')", callbackName];
            [self.webView evaluateJavaScript:callbackStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//                NSLog(@"-- %@  %@", obj, error);
                self->callbackName = nil;
            }];
        }
    } else {
        [Utils showMessage:@"请在上侧框中分别输入要保存数据key和值"];
    }
}

- (void)handleDataGet:(NSDictionary *)paramDict {
    NSString *name = paramDict[@"name"];
    if (name && name.length > 0) {
        id value = [[NSUserDefaults standardUserDefaults] objectForKey:name];
        [Utils showMessage:[NSString stringWithFormat:@"%@", value]];

        if (callbackName && callbackName.length > 0) {
            NSString *callbackStr = [NSString stringWithFormat:@"%@('success: value = %@')", callbackName, value];
            [self.webView evaluateJavaScript:callbackStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//                NSLog(@"-- %@  %@", obj, error);
                self->callbackName = nil;
            }];
        }
    } else {
        [Utils showMessage:@"请在左侧框输入要获取数据对应key"];
    }
}

- (void)handleCallPhone:(NSDictionary *)paramDict {
    NSString *phoneNum = paramDict[@"name"];
    if (phoneNum && phoneNum.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]];
        if ([UIApplication.sharedApplication canOpenURL:url]) {
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
        } else {
            [Utils showMessage:@"该设备不支持电话功能"];
        }
    } else {
        [Utils showMessage:@"请在左侧框输入电话号码"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (originImage == nil || [originImage isKindOfClass:[UIImage class]] == NO) {
        return;
    }
    
    if (callbackName && callbackName.length > 0) {
        NSData * imageData = UIImageJPEGRepresentation(originImage, 0.2);
        NSString *imgBase64 = [imageData base64EncodedStringWithOptions:0];// [imageData base64Encoding];
        NSString *callbackStr = [NSString stringWithFormat:@"%@('%@')", callbackName, imgBase64];
      
        [self.webView evaluateJavaScript:callbackStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//            NSLog(@"-- %@  %@", obj, error);
            self->callbackName = nil;
        }];
    }
}

@end

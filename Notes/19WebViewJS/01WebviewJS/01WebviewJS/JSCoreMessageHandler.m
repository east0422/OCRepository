//
//  JSCoreMessageHandler.m
//  01WebviewJS
//
//  Created by dfang on 2020-5-27.
//  Copyright © 2020 east. All rights reserved.
//

#import "JSCoreMessageHandler.h"
#import "Utils.h"
#import <Photos/Photos.h>

@implementation JSCoreMessageHandler
@synthesize callback;

- (void)addHanderForWebView:(UIWebView *)webView {
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScripeContext"];
    jsContext[@"ocmsgHandler"] = self;
}

- (void)evaluteJSStr {
    JSContext *jsContext = [[JSContext alloc] init];
    JSValue *value1 = [jsContext evaluateScript:@"2 * 50"];
    NSLog(@"2 * 50: %d", value1.toInt32);
    
    [jsContext evaluateScript:@"var num = 5"];
    [jsContext evaluateScript:@"function multiply(num) {return num * 50}"];
    JSValue *value2 = [jsContext evaluateScript:@"multiply(num)"];
    NSLog(@"5 * 50: %d", value2.toInt32);
}

- (void)test {
    NSLog(@"event come from js and just test!");
}

- (void)choosePicFromAlbum:(CallBack)callback {
    self.callback = callback;
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (originImage == nil || [originImage isKindOfClass:[UIImage class]] == NO) {
        return;
    }
    
    if (callback != nil) {
        NSData * imageData = UIImageJPEGRepresentation(originImage, 0.2);
        NSString *imgBase64 = [imageData base64EncodedStringWithOptions:0];// [imageData base64Encoding];
        callback(imgBase64);
    }
}

@end

//
//  Utils.m
//  01WebviewJS
//
//  Created by dfang on 2020-5-27.
//  Copyright © 2020 east. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIViewController *)rootVC {
    return UIApplication.sharedApplication.windows.firstObject.rootViewController;
}

+ (UINavigationController *)navVC {
    return [[self rootVC] navigationController];
}

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    
    [[self rootVC] presentViewController:alert animated:YES completion:nil];
}

+ (void)showMessage:(NSString *)message {
    [self showMessage:message delay:2.0];
}

+ (void)showMessage:(NSString *)message delay:(NSTimeInterval)delay {
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    
    CGFloat viewW = 190;
    CGFloat viewH = 50;
    CGFloat viewX = (UIScreen.mainScreen.bounds.size.width - viewW) * 0.5;
    CGFloat viewY = (UIScreen.mainScreen.bounds.size.height - viewH) * 0.5;
    
    UIView *showview =  [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    showview.backgroundColor = [UIColor blackColor];
    showview.layer.cornerRadius =4.0;
    showview.clipsToBounds = YES;
    [window addSubview:showview];
    
    CGFloat labelMargin = 8.0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelMargin, 0, viewW - labelMargin*2.0, viewH)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    [showview addSubview:label];
    
    
    [UIView animateWithDuration:1.0 delay:delay options:0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end

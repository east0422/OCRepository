//
//  DelegateViewController.h
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DelegateViewController;

@protocol DelegateViewControllerDelegate <NSObject>

@optional
- (void)delegateViewController:(DelegateViewController *)delegateVC goBackWithParam:(NSString *)param;

@end

@interface DelegateViewController : UIViewController

@property (nonatomic, assign) id<DelegateViewControllerDelegate> delegate;

@end

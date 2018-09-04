//
//  BlockViewController.h
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock)(NSString *param);

@interface BlockViewController : UIViewController

@property (nonatomic, copy) CallBackBlock callbackBlock;

// block传值方法
- (void)getParamWithBlock:(CallBackBlock)callbackBlock;

@end

//
//  SingletonViewController.h
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallbackBlock)();

@interface SingletonViewController : UIViewController

@property (nonatomic, copy) CallbackBlock callbackBlock;

@end

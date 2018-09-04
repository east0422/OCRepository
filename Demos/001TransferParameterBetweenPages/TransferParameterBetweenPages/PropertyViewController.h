//
//  PropertyViewController.h
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyViewController : UIViewController

@property (nonatomic, strong) NSString *name;

- (instancetype)initPropertyVCWithName: (NSString *)name;

@end
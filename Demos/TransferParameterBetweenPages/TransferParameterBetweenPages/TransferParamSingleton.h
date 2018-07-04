//
//  TransferParamSingleton.h
//  TransferParameterBetweenPages
//
//  Created by dfang on 2018-7-4.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferParamSingleton : NSObject

@property (nonatomic, copy) NSString *param;

+ (instancetype)defaultSingleton;

@end

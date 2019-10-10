//
//  ShopView.h
//  002UIScrollView
//
//  Created by dfang on 2019-9-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopView : UIView

@property (nonatomic, strong) ShopModel *model;

+ (instancetype)shopView;

@end

NS_ASSUME_NONNULL_END

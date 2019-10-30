//
//  CarTableViewCellXib.h
//  005UITableView
//
//  Created by dfang on 2019-10-28.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarModel;

#define XIBREUSECELLID @"xibReuseCellId"

NS_ASSUME_NONNULL_BEGIN

@interface CarTableViewCellXib : UITableViewCell

@property (nonatomic, strong) CarModel *car;

+ (instancetype)loadFromNib;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

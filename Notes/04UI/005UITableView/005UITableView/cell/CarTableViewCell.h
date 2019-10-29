//
//  CarTableViewCell.h
//  005UITableView
//
//  Created by dfang on 2019-10-28.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

#define REUSECELLID @"reuseCellId"

NS_ASSUME_NONNULL_BEGIN

@interface CarTableViewCell : UITableViewCell

@property (nonatomic, strong) CarModel *car;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

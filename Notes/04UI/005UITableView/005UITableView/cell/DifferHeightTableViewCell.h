//
//  DifferHeightTableViewCell.h
//  005UITableView
//
//  Created by dfang on 2019-10-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DifferHeightModel;

#define DIFFERREUSECELLID @"differReusecellid"

NS_ASSUME_NONNULL_BEGIN

@interface DifferHeightTableViewCell : UITableViewCell

@property (nonatomic, strong) DifferHeightModel *differModel;

+ (instancetype)cellWithTableview:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

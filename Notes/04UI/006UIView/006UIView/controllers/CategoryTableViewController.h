//
//  CategoryTableViewController.h
//  006UIView
//
//  Created by dfang on 2019-11-11.
//  Copyright © 2019年 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellDidClick)(NSIndexPath *selectIndexPath, NSString *categoryName);

@interface CategoryTableViewController : UITableViewController

@property (nonatomic, copy) CellDidClick cellClickCallback;

@end

NS_ASSUME_NONNULL_END

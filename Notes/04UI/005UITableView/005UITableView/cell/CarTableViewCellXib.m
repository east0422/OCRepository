//
//  CarTableViewCellXib.m
//  005UITableView
//
//  Created by dfang on 2019-10-28.
//  Copyright © 2019年 east. All rights reserved.
//

#import "CarTableViewCellXib.h"
#import "CarModel.h"

@interface CarTableViewCellXib ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation CarTableViewCellXib

- (void)downloadImage
{
    NSURL *imageUrl = [NSURL URLWithString:self.car.icon];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    // self.iconImageView.image = image; // 需要在主线程更新
    [self.iconImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}

- (void)setCar:(CarModel *)car {
    _car = car;
    self.nameLabel.text = car.name;
    self.priceLabel.text = car.price;
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:car.icon];
    [operationQueue addOperation:op];
}

+ (instancetype)loadFromNib {
    // 先创建nib再创建对象
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]];
   return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    CarTableViewCellXib *cell = [tableView dequeueReusableCellWithIdentifier:XIBREUSECELLID];
    if (!cell) {
        cell = [CarTableViewCellXib loadFromNib];
    }
    return cell;
}

@end

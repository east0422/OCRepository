//
//  ImageViewCornerRadiusVC.m
//  001UIImageView
//
//  Created by dfang on 2019-8-14.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ImageViewCornerRadiusVC.h"
#import "UIImage+CornerRadius.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat CORNERRADIUS = 50;

@interface ImageViewCornerRadiusVC () <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewCornerRadiusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"圆角处理";
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSLog(@"selected item: %@", item.title);
    switch (item.tag) {
        case 0: // 复原
        {
            self.imageView.layer.masksToBounds = NO;
            self.imageView.layer.mask = nil;
            
            self.imageView.image = [UIImage imageNamed:@"fish.jpg"];
        }
            break;
        case 1: // 属性
        {
            self.imageView.layer.cornerRadius = CORNERRADIUS;
            // masksToBounds是对layer的切割
//            self.imageView.layer.masksToBounds = YES;
            // clipsToBounds是对view的切割
            self.imageView.clipsToBounds = YES;
        }
            break;
        case 2: // UIImage扩展
        {
            self.imageView.image = [[UIImage imageNamed:@"fish.jpg"] east_imageWithCornerRadius:CORNERRADIUS inBound:self.imageView.bounds];
        }
            break;
        case 3: // 遮罩
        {
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:CORNERRADIUS];
            layer.path = bezierPath.CGPath;
            self.imageView.layer.mask = layer;
        }
            break;
        default:
            break;
    }
}

@end

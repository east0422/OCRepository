//
//  FirstViewController.m
//  003OpenCV
//
//  Created by dfang on 2018-11-29.
//  Copyright © 2018年 east. All rights reserved.
//

#import "FirstViewController.h"
#import "UIImage+OpenCV.h"
#import <opencv2/imgcodecs/ios.h>

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)restoreClicked:(UIButton *)sender {
    self.imageView.image = [UIImage imageNamed:@"mars"];
}

- (IBAction)grayClicked:(UIButton *)sender {
    UIImage *image = [UIImage imageNamed:@"mars"];
    
    Mat srcMat, dstMat;
//    UIImageToMat(image, srcMat);
//    cvtColor(srcMat, dstMat, COLOR_BGR2GRAY);
////    self.imageView.image = MatToUIImage(dstMat);
//
//    cvtColor(dstMat, srcMat, COLOR_GRAY2BGR);
//    self.imageView.image = MatToUIImage(srcMat);
    
    // use UIImage+OpenCV
//    srcMat = [UIImage cvMatFromUIImage:image isGray:NO];
//    cvtColor(srcMat, dstMat, CV_BGR2GRAY);
//    self.imageView.image = [UIImage imageFromCVMat:dstMat];
    
    self.imageView.image = [UIImage imageFromCVMat: [UIImage cvMatFromUIImage:image isGray:YES]];
}

@end

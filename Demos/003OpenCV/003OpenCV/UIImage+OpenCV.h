//
//  UIImage+OpenCV.h
//  003OpenCV
//
//  Created by dfang on 2018-11-29.
//  Copyright © 2018年 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

using namespace cv;

@interface UIImage (OpenCV)

// covert uiimage to mat
+ (Mat)cvMatFromUIImage: (UIImage *)image isGray: (BOOL)isGray;

// convert mat to uiimage
+ (UIImage *)imageFromCVMat: (Mat)mat;

@end

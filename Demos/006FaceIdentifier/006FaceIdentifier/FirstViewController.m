//
//  FirstViewController.m
//  006FaceIdentifier
//
//  Created by dfang on 2019-8-9.
//  Copyright © 2019年 east. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreImage/CoreImage.h>

@interface FirstViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *faceCountLabel; // 人脸统计结果标签
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSArray *imageList; // 图片数组
@property (assign, nonatomic) NSInteger curIndex; // 当前显示图片数组索引

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageList = @[@"face-1.jpeg", @"face-2.jpeg", @"face-3.jpeg", @"face-4.jpeg", @"face-5.jpeg", @"face-6.jpeg", @"face-7.jpeg", @"face-8.jpeg"];
    _curIndex = 0;
    
    [self faceDetection];
}

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

// 上一张
- (IBAction)preClicked:(UIBarButtonItem *)sender {
    if (self.curIndex == -1) {
        self.curIndex = self.imageList.count - 1;
        [self faceDetection];
        return;
    }
    
    if (self.curIndex > 0) {
        self.curIndex--;
        [self faceDetection];
    } else {
        // 已是第一张了
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前已是第一张了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// 下一张
- (IBAction)nextClicked:(UIBarButtonItem *)sender {
    if (self.curIndex == -1) {
        self.curIndex = 0;
        [self faceDetection];
        return;
    }
    
    if (self.curIndex < self.imageList.count - 1) {
        self.curIndex++;
        [self faceDetection];
    } else {
       // 已是最后一张了
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前已是最后一张了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// 打开相机
- (IBAction)openCamera: (UIButton *)button {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 从图库中选择图片
- (IBAction)chooseFromCamera:(UIButton *)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)faceDetection {
    // 删除图片视图上添加的所有子视图
    for(UIView *subView in self.imageView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    if (self.curIndex >= 0 && self.curIndex < self.imageList.count) {
        self.imageView.image = [UIImage imageNamed:self.imageList[self.curIndex]];
    }
    
    // 定义识别器参数
    NSDictionary *dicts = [NSDictionary dictionaryWithObjectsAndKeys:CIDetectorAccuracyHigh, CIDetectorAccuracy, nil];
    // 定义识别器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:dicts];
    // self.imageView.image.CIImage 为nil。(If the UIImage object was initialized using a CGImageRef, the value of the property is nil)
    CIImage *ciimage = [[CIImage alloc] initWithImage:self.imageView.image];
    // CoreImage坐标系和UIKit坐标系不同，做一个转换
    CGSize imgSize = ciimage.extent.size;
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -imgSize.height);
    // 计算imageView实际大小和位置
    CGSize imageViewSize = _imageView.bounds.size;
    CGFloat scaleX = (imageViewSize.width/imgSize.width);
    CGFloat scaleY = (imageViewSize.height/imgSize.height);
    CGFloat offsetX = (imageViewSize.width - imgSize.width * scaleX) / 2;
    CGFloat offsetY = (imageViewSize.height - imgSize.height * scaleY) / 2;

    // 进行识别
    // 判断了CIImage是否带有方向的元数据，如果带的话就调用featuresInImage:options这个方法，因为方向对CIDetector来说至关重要，直接导致识别的成功与否；而有的图片没有方向这些元数据，就调用featuresInImage方法
    id orientation = [[ciimage properties] valueForKey:(__bridge_transfer NSString *)kCGImagePropertyOrientation];
    NSArray *features = @[];
    if (orientation == nil) {
        features = [detector featuresInImage: ciimage];
    } else {
        NSDictionary *opts = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
        features = [detector featuresInImage: ciimage options:opts];
    }
    
    self.faceCountLabel.text = [NSString stringWithFormat:@"识别人脸数为:%lu", (unsigned long)features.count];
    // 处理识别结果
    if (features.count > 0) {
        for (CIFaceFeature *feature in features) {
            // 极少数返回坐标不太准确
//            NSLog(@"面部坐标--->bounds: %@", NSStringFromCGRect(feature.bounds));
            // 转换坐标
            CGRect borderBounds = CGRectApplyAffineTransform(feature.bounds, transform);
            borderBounds = CGRectApplyAffineTransform(borderBounds, CGAffineTransformMakeScale(scaleX, scaleY));
            borderBounds.origin.x += offsetX;
            borderBounds.origin.y += offsetY;
            // 画一个红色外框
            UIView *borderView = [[UIView alloc] initWithFrame:borderBounds];
            borderView.layer.borderColor = UIColor.redColor.CGColor;
            borderView.layer.borderWidth = 2;
            borderView.backgroundColor = UIColor.clearColor;
            // 将红色外框视图添加到图片视图上
            [self.imageView addSubview:borderView];
        
//            NSLog(@"面部坐标--->bounds: %@", NSStringFromCGRect(borderView.frame));
//            if (feature.leftEyeClosed) {
//                NSLog(@"左眼闭着");
//            }
//            if (feature.rightEyeClosed) {
//                NSLog(@"右眼闭着");
//            }
//            if (feature.hasSmile) {
//                NSLog(@"在笑");
//            }
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    self.curIndex = -1;
    self.imageView.image = info[UIImagePickerControllerEditedImage];
    [self faceDetection];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

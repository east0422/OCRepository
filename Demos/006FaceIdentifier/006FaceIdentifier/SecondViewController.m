//
//  SecondViewController.m
//  006FaceIdentifier
//
//  Created by dfang on 2019-8-9.
//  Copyright © 2019年 east. All rights reserved.
//

#import "SecondViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SecondViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session; // 协调输入输出流的数据
@property (strong, nonatomic) AVCaptureDevice *device; // 设备
@property (strong, nonatomic) AVCaptureDeviceInput *input; // 输入流
@property (strong, nonatomic) AVCaptureMetadataOutput *metaDataOutput; // 输出流，用于二维码识别以及人脸识别
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview; // 预览层

@property (strong, nonatomic) CALayer *borderLayer; // 人脸框

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 初始化相机流
    [self initCamera];
    
    // 添加预览层
    [self.view.layer insertSublayer:self.preview atIndex:0];
//    [self.view.layer addSublayer:self.preview];
    // 将红色外框添加到预览层上
    [self.view.layer addSublayer: self.borderLayer];
}

- (void)initCamera {
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    // 获取摄像设备
    _device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    // 输入流
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error != nil) {
        NSLog(@"input init error: %@", error.localizedDescription);
    }
    if ([self.session canAddInput:_input]) {
        [self.session addInput:_input];
    }
    // 输出流
    dispatch_queue_t queue = dispatch_get_main_queue();
    _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理 在主线程里刷新
    [_metaDataOutput setMetadataObjectsDelegate:self queue:queue];
    if ([self.session canAddOutput:_metaDataOutput]) {
        [self.session addOutput:_metaDataOutput];
    }
    _metaDataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
    
    // 开启输入流，获取数据到输出流
    [_session startRunning];
}

- (AVCaptureVideoPreviewLayer *)preview {
    if (_preview == nil) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = CGRectMake((self.view.frame.size.width - 300)/2.0, 100, 300, 300);
        _preview.cornerRadius = 150;
        _preview.borderColor = UIColor.grayColor.CGColor;
        _preview.borderWidth = 2;
    }
    return _preview;
}

- (CALayer *)borderLayer {
    if (_borderLayer == nil) {
        _borderLayer = [CALayer layer];
        _borderLayer.borderColor = UIColor.redColor.CGColor;
        _borderLayer.borderWidth = 2;
        _borderLayer.backgroundColor = UIColor.clearColor.CGColor;
        _borderLayer.hidden = YES;
    }
    return _borderLayer;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_session) {
        [_session stopRunning];
        _session = nil;
    }
}

// AVCaptureMetadaOutputDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *item in metadataObjects) {
        if (item.type == AVMetadataObjectTypeFace) {
//            AVMetadataObject *transformItem = [self.preview transformedMetadataObjectForMetadataObject:item];
            AVMetadataObject *transformItem = [output transformedMetadataObjectForMetadataObject:item connection:connection];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self showFaceBorder:transformItem.bounds];
                });
            });
        }
    }
}

- (void)showFaceBorder: (CGRect)faceBounds {
    CGRect viewBounds = self.preview.frame;
//    NSLog(@"preview bounds:%@", NSStringFromCGRect(self.preview.frame));
    // position
    CGFloat x = viewBounds.origin.x + faceBounds.origin.x * viewBounds.size.width;
    CGFloat y = viewBounds.origin.y + faceBounds.origin.y * viewBounds.size.height;
    // size
    CGFloat width = faceBounds.size.width * viewBounds.size.width;
    CGFloat height = faceBounds.size.height * viewBounds.size.height;
    
    self.borderLayer.frame = CGRectMake(x, y, width, height);
//    NSLog(@"aaaa bounds: %@", NSStringFromCGRect(self.borderLayer.bounds));
    
    self.borderLayer.hidden = NO;
}

@end

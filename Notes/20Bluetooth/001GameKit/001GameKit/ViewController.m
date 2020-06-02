//
//  ViewController.m
//  001GameKit
//
//  Created by dfang on 2020-1-6.
//  Copyright © 2020 east. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, GKPeerPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) GKSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/** 连接蓝牙设备 */
- (IBAction)connectDevice:(UIButton *)sender {
    GKPeerPickerController *ppc = [[GKPeerPickerController alloc] init];
    ppc.delegate = self;
    [ppc show];
}

/** 选择图片/打开相机 */
- (IBAction)selectPic:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    switch (sender.tag) {
        case 1:
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) { // 相册
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            } else if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)]) { // 图库
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            break;
        case 2:
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) { // 相机
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera ;
            }
            break;
        default:
            return;
    }
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

/** 发送图片 */
- (IBAction)sendPic:(UIButton *)sender {
    if (self.imageView.image == nil) {
        return;
    }
    
    NSData *data = UIImagePNGRepresentation(self.imageView.image);
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    // 依据mediaType做不同处理
//    NSString *mediaType = info[UIImagePickerControllerMediaType];
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GKPeerPickerControllerDelegate
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    [picker dismiss];
    
    self.session = session;
    
    [self.session setDataReceiveHandler:self withContext:nil];
}

// 接收数据处理
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    if (!data) return;

    UIImage *image = [UIImage imageWithData:data];
    self.imageView.image = image;
}

@end

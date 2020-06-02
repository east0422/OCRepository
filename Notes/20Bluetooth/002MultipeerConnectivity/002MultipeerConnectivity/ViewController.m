//
//  ViewController.m
//  002MultipeerConnectivity
//
//  Created by dfang on 2020-1-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define SERVICETYPE @"MultipeerConnectivityTest"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCBrowserViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (nonatomic, strong) MCSession *mcsession;
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

/** 懒加载 */
- (MCPeerID *)peerID {
    if (_peerID == nil) {
        _peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    }
    return _peerID;
}

- (MCSession *)mcsession {
    if (_mcsession == nil) {
        _mcsession = [[MCSession alloc] initWithPeer:self.peerID];
    }
    
    return _mcsession;
}

- (MCBrowserViewController *)browserVC {
    if (_browserVC == nil) {
        _browserVC = [[MCBrowserViewController alloc] initWithServiceType:SERVICETYPE session:self.mcsession];
        _browserVC.delegate = self;
    }
    return _browserVC;
}

- (MCAdvertiserAssistant *)advertiserAssistant {
    if (_advertiserAssistant == nil) {
        _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICETYPE discoveryInfo:nil session:self.mcsession];
    }
    return _advertiserAssistant;
}

/** 广播开启开关切换 */
- (IBAction)switchChanged:(UISwitch *)sender {
    self.connectBtn.enabled = sender.isOn;
    if (sender.isOn) { // 开始广播
        [self.advertiserAssistant start];
    } else {
        [self.advertiserAssistant stop];
    }
}

- (IBAction)connectDevice:(UIButton *)sender {
    [self.advertiserAssistant start];
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (IBAction)choseImage:(UIButton *)sender {
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

- (IBAction)sendImage:(UIButton *)sender {
    if (!self.imageView.image) return;
    
    UIImage *image = self.imageView.image;
    NSData *data = UIImagePNGRepresentation(image);
   
    if (self.peerID != nil) {
        [self.mcsession sendData:data toPeers:@[self.peerID] withMode:MCSessionSendDataReliable error:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    // 依据mediaType做不同处理
//    NSString *mediaType = info[UIImagePickerControllerMediaType];
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info {
    self.peerID = peerID;
    return YES;
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    UIImage *image = [[UIImage alloc] initWithData:data];
    if(image != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }
}

@end


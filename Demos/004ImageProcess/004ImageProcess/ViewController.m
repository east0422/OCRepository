//
//  ViewController.m
//  004ImageProcess
//
//  Created by dfang on 2019-3-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ViewController.h"
#import "Utils/ImageUtils.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)recoveryClicked:(id)sender {
    self.imageView.image = [UIImage imageNamed:@"monkey.jpg"]; // mars2.png
}


- (IBAction)processClicked:(UIButton *)sender {
    UIImage *newImage = [ImageUtils imageWhitening:self.imageView.image];
    self.imageView.image = newImage;
}

@end

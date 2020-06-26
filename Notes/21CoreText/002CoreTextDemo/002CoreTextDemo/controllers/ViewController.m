//
//  ViewController.m
//  002CoreTextDemo
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"
#import "CTData.h"
#import "CTImageData.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CTDisplayView *ctView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctViewHeightConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self showTextAndImage];
    
    [self showTextAndImageAndLink];
}

- (void)showTextAndImage {
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.ctView.bounds.size.width;
    
    //    CTData *data = [CTFrameParser parseContent:@"测试CoreText绘制" config:config];
    
    NSString *content = @"好好学习，努力向上！前面10个红色，后面文字保持配置黑色，仅仅只是测试啊啊啊啊啊啊啊";
    NSDictionary *attr = [CTFrameParser attributesWithConfig:config];
    
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attr];
    [mutableAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 10)];
    // 和CTFrameParser的attributesWithConfig方法中保持一致
    [mutableAttStr addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 10)];
    
    NSMutableArray *imageArr = NSMutableArray.array;
    CTImageData *ctImageData1 = [[CTImageData alloc] init];
    ctImageData1.name = @"vip";
    ctImageData1.index = [mutableAttStr length];
    [imageArr addObject:ctImageData1];
    // 添加图片占位符
    NSDictionary *dic1 = @{@"width": @83, @"height": @50};
    NSAttributedString *attrStr1 = [CTFrameParser parseImageDataFromNSDictionary:dic1 config:config];
    [mutableAttStr appendAttributedString: attrStr1];
    
    NSAttributedString *midStr = [[NSAttributedString alloc] initWithString:@"两张图片中间添加文字"];
    [mutableAttStr appendAttributedString:midStr];
    
    CTImageData *ctImageData2 = [[CTImageData alloc] init];
    ctImageData2.name = @"120";
    ctImageData2.index = [mutableAttStr length];
    [imageArr addObject:ctImageData2];
    NSDictionary *dic2 = @{@"width": @120, @"height": @120};
    NSAttributedString *attrStr2 = [CTFrameParser parseImageDataFromNSDictionary:dic2 config:config];
    [mutableAttStr appendAttributedString: attrStr2];
    
    CTData *data = [CTFrameParser parseAttributedContent:mutableAttStr config:config];
    
    data.imageArr = imageArr;
    
    self.ctView.data = data;
    
    // storyboard中添加了约束，更改frame不起作用，直接更改约束就行
//    CGRect newFrame = CGRectMake(self.ctView.bounds.origin.x, self.ctView.bounds.origin.y, self.ctView.bounds.size.width, data.height);
//    self.ctView.frame = newFrame;
    _ctViewHeightConstraint.constant = data.height;
    
    self.ctView.backgroundColor = [UIColor yellowColor];
}

- (void)showTextAndImageAndLink {
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    CTData *data = [CTFrameParser parseTemplateFile:path config:config];
    self.ctView.data = data;
    
    _ctViewHeightConstraint.constant = data.height;
    self.ctView.backgroundColor = [UIColor whiteColor];
}

@end

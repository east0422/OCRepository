//
//  ViewController.m
//  01WebviewJS
//
//  Created by dfang on 2020-5-25.
//  Copyright © 2020 east. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "WKUIDelegateDialog.h"
#import "WKMessageHandler.h"
#import "SubNSURLProtocol.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *wkWebView;

// 处理js弹出框
@property (nonatomic, strong) WKUIDelegateDialog *uidelegateDialog;

@end

@implementation ViewController

- (void)testNSURLProtocol {
    // 拦截url
    [NSURLProtocol registerClass:[SubNSURLProtocol class]];
    
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testNSURLProtocol];
    
    WKUserContentController *userController = self.wkWebView.configuration.userContentController;
    [userController addScriptMessageHandler:[[WKMessageHandler alloc] initWithWebView:self.wkWebView] name:@"call"];

    _uidelegateDialog = [[WKUIDelegateDialog alloc] init];
    self.wkWebView.UIDelegate = _uidelegateDialog;
    NSURL *urlPath = [[NSBundle mainBundle] URLForResource:@"html/index.html" withExtension:nil];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:urlPath]];
}

- (void)dealloc {
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"call"];
}

@end

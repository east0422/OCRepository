//
//  WKWebViewController.m
//  01WebviewJS
//
//  Created by dfang on 2020-5-26.
//  Copyright © 2020 east. All rights reserved.
//

#import "WKWebViewController.h"
#import "WKUIDelegateDialog.h"
#import "WKMessageHandler.h"

@interface WKWebViewController ()

// 处理js弹出框
@property (nonatomic, strong) WKUIDelegateDialog *uidelegateDialog;

@end

@implementation WKWebViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // ios13默认顶部有一段间距
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    self.webView = webView;
    
    WKUserContentController *userController = self.webView.configuration.userContentController;
    [userController addScriptMessageHandler:[[WKMessageHandler alloc] initWithWebView:self.webView] name:@"call"];
    
    _uidelegateDialog = [[WKUIDelegateDialog alloc] init];
    self.webView.UIDelegate = _uidelegateDialog;
    
    if (self.urlStr && self.urlStr.length > 0) {
        if ([self.urlStr hasPrefix:@"http"]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:self.urlStr ofType:@"html"];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        }
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"html/index" ofType:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    }
}

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"call"]; 
}

@end

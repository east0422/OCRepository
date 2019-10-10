//
//  ViewController.m
//  002UIScrollView
//
//  Created by dfang on 2019-9-29.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ViewController.h"
#import "ShopView.h"
#import "ShopModel.h"
#import "CustomScrollViewDelegate.h"
#import "CustomPageView.h"

#define SHOPWIDTH 90
#define SHOPHEIGHT 120
#define SHOPPADDING 10
#define SHOPCOLUMN 3

@interface ViewController () // <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<ShopModel *> *shops;
@property (nonatomic, assign) NSInteger index; // 当前商品在shops中索引
@property (nonatomic, strong) CustomScrollViewDelegate *cusScrollviewDelegate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.index = 0;
    // scrollView可滚动范围
    self.scrollView.contentSize = CGSizeMake(SHOPCOLUMN * (SHOPWIDTH + SHOPPADDING), (self.shops.count / SHOPCOLUMN) * (SHOPHEIGHT + SHOPPADDING));
    // 给scrollview增加额外的滚动区域，通常用于设置顶部导航栏
    self.scrollView.contentInset = UIEdgeInsetsMake(40, 10, 20, 10);
    // contentsize左上角与scrollview左上角的差值
    self.scrollView.contentOffset = CGPointMake(-10, -40);

    // note: 是否显示水平垂直滚动条，两个滚动条也是scrollview的两个UIImageView子控件，使用scrollview子控件是需要注意一下
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.showsVerticalScrollIndicator = NO;
    
    // 代理通常设为自己，但也可以设置为其他实现对应协议的对象
//    self.scrollView.delegate = self;
    
    // note: delegate是弱引用，直接将生成的代理对象赋值给它，赋值完后会释放掉的
//    self.scrollView.delegate = [[CustomScrollViewDelegate alloc] init];
    
    // note: 先生成局部变量scrollViewDelegate再赋值给弱引用代理属性，局部变量会在该方法体结束后释放掉，不能一直保存
//    CustomScrollViewDelegate *scrollViewDelegate = [[CustomScrollViewDelegate alloc] init];
//    self.scrollView.delegate = scrollViewDelegate;
    
    // 定义一个强引用变量用来保存代理属性
    self.cusScrollviewDelegate = [[CustomScrollViewDelegate alloc] init];
    self.scrollView.delegate = self.cusScrollviewDelegate;
    
    [self testCusPageView];
    
//    // 格式化测试
//    for (int i = 0; i < 3; i++) {
//        NSLog(@"%03d, 1%02d", i, i); // 000, 100 / 001, 101 / 002, 102
//    }
}

- (void)testCusPageView {
    // 删除其他视图
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    CustomPageView *pageView = [CustomPageView pageView];
    CustomPageView *pageView = [[CustomPageView alloc] init];
    pageView.frame = CGRectMake(50, 150, 250, 120);
    pageView.frame = CGRectMake(50, 250, 250, 120);
//    pageView.images = @[@"100", @"101", @"102"];
    pageView.imageNames = @[@"100", @"101", @"102"];
    pageView.pageCurColor = [UIColor yellowColor];
    pageView.pageTintColor = [UIColor redColor];
    [self.view addSubview:pageView];
    // note: 这里多次更改frame但是layoutSubviews只会执行一次是因为多次更改frame是在一次运行循环中，只有运行循环结束时才会选入ui的所有更改
    pageView.frame = CGRectMake(40, 300, 250, 200);
}

- (NSMutableArray<ShopModel *> *)shops {
    if (!_shops) {
        _shops = [NSMutableArray array];
        // 手动创建model添加
//        for (int i = 0; i < 12; i++) {
//            NSString *title = [NSString stringWithFormat:@"第%ld个", self.index + 1];
//            ShopModel *shopModel = [ShopModel shopWithDic:@{@"icon": @"icon-80", @"title": title}];
//            [_shops addObject:shopModel];
//        }
        
        // 从bundle中读取，前面是否需要加目录名可查看Copy Bundle Resources中是否带有目录
        // 1. 没有目录直接读取文件
//        NSString *shopsFile = [[NSBundle mainBundle] pathForResource:@"shops" ofType:@"plist"];
        // 2. 黄色虚拟目录，拖进项目时勾选Create Groups
//        NSString *shopsFile = [[NSBundle mainBundle] pathForResource:@"shops1" ofType:@"plist"];
        // 3. 蓝色实体目录，拖进项目时勾选Create Folder Reference
        NSString *shopsFile = [[NSBundle mainBundle] pathForResource:@"shops2/shops2" ofType:@"plist"];

        NSArray *shopList = [NSArray arrayWithContentsOfFile:shopsFile];
        for (NSDictionary *dic in shopList) {
            ShopModel *model = [ShopModel shopWithDic:dic];
            [_shops addObject:model];
        }
    }
    return _shops;
}

- (IBAction)addClicked:(UIButton *)sender {
    if (self.shops.count == 0) {
        [self showAlert:@"添加" withMessage:@"没有可添加的了！"];
        return;
    }
    if (self.index >= self.shops.count) {
        [self showAlert:@"添加" withMessage:@"已经添加满了，不能添加了！"];
        return;
    }
    // 当前添加所处行，每行显示三个
    NSInteger row = self.index / SHOPCOLUMN;
    NSInteger col = self.index % SHOPCOLUMN;
//    ShopView *shopView = [[ShopView alloc] initWithFrame:CGRectMake(col * (SHOPPADDING + SHOPWIDTH) , row * (SHOPPADDING + SHOPHEIGHT), SHOPWIDTH, SHOPHEIGHT)];
    ShopView *shopView = [ShopView shopView];
    shopView.frame = CGRectMake(col * (SHOPPADDING + SHOPWIDTH) , row * (SHOPPADDING + SHOPHEIGHT), SHOPWIDTH, SHOPHEIGHT);
    shopView.tag = self.index + 1;
    shopView.model = self.shops[self.index];
    [self.scrollView addSubview:shopView];
    self.index++;
}
- (IBAction)delClicked:(UIButton *)sender {
    if (self.index < 1) {
        [self showAlert:@"删除" withMessage:@"已经没有了，不能删除了！"];
        return;
    }
    UIView *subView = [self.scrollView viewWithTag:self.index];
    [subView removeFromSuperview];
    self.index--;
}

- (void)showAlert:(NSString *)title withMessage: (NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:(UIAlertActionStyleDefault) handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 #pragma mark --- scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollview滚动了！");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollview即将开始拖动！");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollview停止拖动！");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollview滚动即将开始惯性减速！");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollview滚动惯性减速结束！");
}
*/

@end

//
//  ViewController.m
//  007DataSpider
//
//  Created by dfang on 2019-9-24.
//  Copyright © 2019年 east. All rights reserved.
//

#import "ViewController.h"

#define BASEURL @"http://www.budejie.com/"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self spider];
}

// 注意：抓取数据时所有请求方法都是同步的
- (void)spider {
    NSURL *url = [NSURL URLWithString:BASEURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // NSSession是异步的，NSConnection同步
//    NSURLSession *sesssion = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [sesssion dataTaskWithURL:url];
    
    NSError *error = nil;
    // 请求返回数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&error];
    if (error) {
        NSLog(@"error:%@", error);
        return;
    }
    NSString *html = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
//    NSLog(@"html:%@",html);
    
    NSString *pattern = @"<div class=\"link\">(.*?)</div>";
    NSString *result = [self filterWith:pattern in:html];
    NSLog(@"result:%@", result);
    
    NSString *labelPattern = @"<a  .*?  href=\"(.*?)\">(.*?)</a>";
    NSArray *arr = [self matchWith:labelPattern in:result andKeys:@[@"href", @"label"]];
    NSString *matchResult = [self arrayToString:arr];
    NSLog(@"matchResult:%@", matchResult);
}

// 查找匹配内容，返回第一个匹配的
- (NSString *)filterWith:(NSString *)pattern in:(NSString *)contents {
    NSError *error = nil;
    NSRegularExpression *regularExp = [NSRegularExpression regularExpressionWithPattern:pattern options:(NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators) error:&error];
    if (error) {
        NSLog(@"匹配发送错误：%@", error);
        return nil;
    }
    NSTextCheckingResult *textCheckingResult = [regularExp firstMatchInString:contents options:0 range:NSMakeRange(0, contents.length)];
    if (!textCheckingResult) {
        NSLog(@"没有匹配到和%@相符的内容", pattern);
        return nil;
    }
    NSRange resultRange = [textCheckingResult rangeAtIndex:0];
    NSString *result = [contents substringWithRange:resultRange];
    
    return result;
}

- (NSArray *)matchWith:(NSString *)pattern in:(NSString *)contents andKeys:(NSArray *)keys {
    NSError *error = nil;
    NSRegularExpression *regularExp = [NSRegularExpression regularExpressionWithPattern:pattern options:(NSRegularExpressionCaseInsensitive | NSRegularExpressionAllowCommentsAndWhitespace | NSRegularExpressionDotMatchesLineSeparators) error:&error];
    if (error) {
        NSLog(@"匹配发送错误：%@", error);
        return nil;
    }
    NSArray<NSTextCheckingResult *> *arr = [regularExp matchesInString:contents options:0 range:NSMakeRange(0, contents.length)];
    
    if (!arr || arr.count < 1) {
        NSLog(@"没有匹配到和%@相符的内容", pattern);
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSTextCheckingResult *tcresult in arr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i = 0; i < keys.count; i++) {
            NSString *value = [contents substringWithRange:[tcresult rangeAtIndex: i + 1]];
            [dic setObject:value forKey:keys[i]];
        }
        [result addObject:dic];
    }
    
    return result;
}

- (NSString *)arrayToString:(NSArray *)arr {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    for (id e in arr) {
        [strM appendString:@"\t{\n"];
        if ([e isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)e;
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [strM appendFormat:@"\t%@ = %@,\n", key, obj];
            }];
        } else if ([e isKindOfClass:[NSString class]]) {
            [strM appendFormat:@"\t%@,\n", e];
        }
        [strM appendString:@"\t},\n"];
    }
    [strM appendString:@"}\n"];
    return strM;
}

@end

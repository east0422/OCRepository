//
//  main.m
//  01FileManager
//
//  Created by dfang on 2018-8-16.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

void testDir();
void testFileManager();
void testWriteAndRead();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testDir();
//        testFileManager();
        testWriteAndRead();
    }
    return 0;
}

void testDir() {
    // 沙盒路径
    NSString *homeDir = NSHomeDirectory();
    // Document目录
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    // Cache目录
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    // Preferences
    NSString *preDir = [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory,NSUserDomainMask,YES) firstObject];
    // Libaray目录
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) firstObject];
    // tmp目录
    NSString *tmpDir = NSTemporaryDirectory();
    NSLog(@"\nhome: %@,\ndoc:%@,\ncacheDir:%@,\npreDir:%@,\nlibDir:%@\ntmpDir:%@", homeDir, docDir, cacheDir, preDir, libDir, tmpDir);
}

void testFileManager() {
    // 沙盒
    NSString *home = NSHomeDirectory();
    
    // 单例模式
    NSFileManager *fm1 = [NSFileManager defaultManager];
//    NSFileManager *fm2 = [NSFileManager defaultManager];
//    NSLog(@"fm1:%@, fm2:%@, fm1==fm: %@", fm1, fm2, fm1 == fm2 ? @"Yes" : @"No");
    
    // 创建文件
    NSString *path = [home stringByAppendingPathComponent:@"file.txt"];
    NSString *contents = @"filemanager测试内容111";
    NSData *data = [contents dataUsingEncoding:NSUTF8StringEncoding];
    BOOL isCreate = [fm1 createFileAtPath:path contents:data attributes:nil];
    NSLog(@"path: %@ create %@", path, isCreate ? @"success" : @"fail");
    
    // 复制文件
    NSString *copyPath = [home stringByAppendingPathComponent:@"file1.txt"];
    BOOL isCopy = [fm1 copyItemAtPath:path toPath:copyPath error:nil];
    NSLog(@"destPath:%@ copy %@", copyPath, isCopy ? @"success" : @"fail");
    
    // 剪切
    NSString *movePath = [home stringByAppendingPathComponent:@"file2.txt"];
    BOOL isMove = [fm1 moveItemAtPath:path toPath:movePath error:nil];
    NSLog(@"move %@", isMove ? @"success" : @"fail");
    
    // 删除
    BOOL isDelete = [fm1 removeItemAtPath:movePath error:nil];
    NSLog(@"delete %@ %@", movePath, isDelete ? @"success" : @"fail");
    
    // 文件属性
    NSDictionary *attrs = [fm1 attributesOfItemAtPath:copyPath error:nil];
    NSLog(@"%@ attrs: %@", copyPath, attrs);
    
    // 获取文件子目录
    NSString *picPath = [home stringByAppendingPathComponent:@"pictures"];
    NSArray *pathArr = [fm1 subpathsAtPath:picPath];
    NSLog(@"%@ subDirs:%@", home, pathArr);
}

void testWriteAndRead() {
    // 写入文件
    NSString *content = @"aShen. All rights rese测试";
    NSString *writePath = [NSHomeDirectory() stringByAppendingPathComponent:@"temp.txt"];
    // atomically: YES 先将写入文件的内容存储到临时文件中，如果成功就会覆盖源文件，NO 直接删除文件的内容，直接写入新的内容
    BOOL isWrit = [content writeToFile:writePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"write into %@ %@", writePath, isWrit ? @"success" : @"fail");
    // 读文件, 开发中读图片用的最多,缓存小
    NSString *str = [[NSString alloc] initWithContentsOfFile: writePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"read from %@ is: %@", writePath, str);
}

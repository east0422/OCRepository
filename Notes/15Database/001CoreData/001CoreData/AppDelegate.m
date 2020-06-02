//
//  AppDelegate.m
//  001CoreData
//
//  Created by dfang on 2020-5-28.
//  Copyright © 2020 east. All rights reserved.
//

#import "AppDelegate.h"
#import "Teacher+CoreDataProperties.h"

@interface AppDelegate ()

@property (nonatomic, assign) BOOL isInserted;

@end

static NSString *ISINSERTEDKEY = @"isInserted";

@implementation AppDelegate

// 添加Teacher
- (void)addTeacherWithName:(NSString *)name andAge:(int32_t)age andGender:(NSNumber *)gender {
    // 获取数据库中实体对象
    Teacher *teacherEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Teacher class]) inManagedObjectContext:self.persistentContainer.viewContext];
    teacherEntity.tid = ([[NSDate now] timeIntervalSince1970] * 1000) ;
    teacherEntity.name = name;
    teacherEntity.age = age;
    teacherEntity.gender = gender;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 编好设置
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isInserted = [userDefaults boolForKey:ISINSERTEDKEY];
    
    if (!self.isInserted) {
        [self addTeacherWithName:@"张三" andAge:20 andGender:@'M'];
        [self addTeacherWithName:@"李四" andAge:30 andGender:@'M'];
        [self addTeacherWithName:@"赵琳" andAge:20 andGender:@'F'];
        [self addTeacherWithName:@"杏花" andAge:38 andGender:@'F'];
        [self addTeacherWithName:@"小王" andAge:20 andGender:@'M'];
    }
    
    // 将偏好设置写入文件
    [userDefaults setBool:YES forKey:ISINSERTEDKEY];
    [userDefaults synchronize];
         
    // 保存数据到持久层
    [self saveContext];
         
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"001CoreData"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

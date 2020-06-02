//
//  AppDelegate.h
//  001CoreData
//
//  Created by dfang on 2020-5-28.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


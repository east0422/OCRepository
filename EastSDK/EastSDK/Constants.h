//
//  Constants.h
//  OCSDK
//
//  Created by dfang on 2018-07-05.
//  Copyright © 2018年 dfang. All rights reserved.
//

#ifndef EastSDKOC_Constants_h
#define EastSDKOC_Constants_h

// Key window
#define getKeyWindow()  [[UIApplication sharedApplication] keyWindow]

// Version
#define OSVersionString() [[UIDevice currentDevice] systemVersion]
#define OSVersionFloat()  [[[UIDevice currentDevice] systemVersion] floatValue]

#define getAppVersion()         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define getAppShortVersion()    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// Load resources
#define loadNibName(name) [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] lastObject];
#define registerCellNib(tableView, name, identifier) [tableView registerNib:[UINib nibWithNibName:name bundle:nil]forCellReuseIdentifier:identifier]

// ARC judgement
#define definedArcMode()  __has_feature(objc_arc)

// Output debug string
#define OutputCurrentDebugInfo() NSLog(@"\n*****************************************\nDebug information:\nFile: %s\nLine: %d\nMethod: [%@ %@]\n*****************************************",__FILE__, __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd))

// Font
#define systemFont(size) [UIFont systemFontOfSize:size]
#define systemBoldFont(size) [UIFont boldSystemFontOfSize:size]

// Color
#define rgbColor(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]
#define rgbaColor(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define refreshLabelTextColor() rgbColor(150, 150, 150)

// System color
#define sysBlackColor()       [UIColor blackColor]
#define sysDarkGrayColor()    [UIColor darkGrayColor]
#define sysLightGrayColor()   [UIColor lightGrayColor]
#define sysWhiteColor()       [UIColor whiteColor]
#define sysGrayColor()        [UIColor grayColor]
#define sysRedColor()         [UIColor redColor]
#define sysGreenColor()       [UIColor greenColor]
#define sysBlueColor()        [UIColor blueColor]
#define sysCyanColor()        [UIColor cyanColor]
#define sysYellowColor()      [UIColor yellowColor]
#define sysMagentaColor()     [UIColor magentaColor]
#define sysOrangeColor()      [UIColor orangeColor]
#define sysPurpleColor()      [UIColor purpleColor]
#define sysBrownColor()       [UIColor brownColor]

#define sysClearColor()       [UIColor clearColor]

// Screen
#define screenBounds [UIScreen mainScreen].bounds
#define screenSize  screenBounds.size
#define screenWidth   screenSize.width
#define screenHeight screenSize.height

// Full Screen
#define FULLWIDTH     375.0
#define FULLHEIGHT    667.0

// scale
#define scaleX    (screenWidth/FULLWIDTH)
#define scaleY    (screenHeight/FULLHEIGHT)

// Rect
#define rectMake(x, y, w, h)  CGRectMake((x)*scaleX, (y)*scaleY, (w)*scaleX, (h)*scaleY)
#define sizeMake(w, h)        CGSizeMake((w)*scaleX, (h)*scaleY)
#define pointMake(x, y)       CGPointMake((x)*scaleX, (y)*scaleY)
#define edgeMake(top, left, bottom, right)    UIEdgeInsetsMake((top)*scaleY, (left)*scaleX, (bottom)*scaleY, (right)*scaleX)

/**
 * App data
 */

// User defaults
#define setUserDefaults(key, object) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define saveUserDefaults()  [[NSUserDefaults standardUserDefaults] synchronize]
#define getUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

// get file path
#define getFilePath(name, suffix) [[NSBundle mainBundle] pathForResource:name ofType:suffix]

// app first launch
#define isAppFirstLaunch()    ![getUserDefaults(@"app_firstlaunch_key") boolValue]
#define setAppFirstLaunched() setUserDefaults(@"app_firstlaunch_key", @1), saveUserDefaults()

// Image
#define loadImage(name)      [UIImage imageNamed:name]
#define loadImageData(data)  [UIImage imageWithData:data]
#define loadImageFile(file)  [UIImage imageWithContentsOfFile:file]

// Path
#define currentDocumentsPath() NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

#endif /* Constants_h */

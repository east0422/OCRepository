//
//  NSObject+EASTKVC.h
//  02KVC
//  自定义KVC
//
//  Created by dfang on 2020-5-12.
//  Copyright © 2020 east. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (EASTKVC)

- (id)EAST_valueForKey:(NSString *)key;

- (void)EAST_setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

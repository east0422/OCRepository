//
//  Person+Alien.h
//  01RuntimeBasic
//
//  Created by dfang on 2020-5-20.
//  Copyright © 2020 east. All rights reserved.
//

#import <AppKit/AppKit.h>


#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (Alien)

@property (nonatomic, copy) NSString *planet;

@end

NS_ASSUME_NONNULL_END

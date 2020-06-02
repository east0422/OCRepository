//
//  Person+Alien.m
//  01RuntimeBasic
//
//  Created by dfang on 2020-5-20.
//  Copyright © 2020 east. All rights reserved.
//

#import "Person+Alien.h"

#import <AppKit/AppKit.h>
#import <objc/message.h>

static const char *kplanet = "kplanet";

@implementation Person (Alien)

- (NSString *)planet {
    return objc_getAssociatedObject(self, &kplanet);
}

- (void)setPlanet:(NSString *)planet {
    objc_setAssociatedObject(self, &kplanet, planet, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

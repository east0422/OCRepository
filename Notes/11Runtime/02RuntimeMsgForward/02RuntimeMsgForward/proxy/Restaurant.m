//
//  Restaurant.m
//  02RuntimeMsgForward
//
//  Created by dfang on 2020-5-25.
//  Copyright © 2020 east. All rights reserved.
//

#import "Restaurant.h"

@interface Restaurant() <RestaurantProtocol>

@end

@implementation Restaurant

- (void)order:(nonnull NSString *)ordername {
    NSLog(@"在饭店订购了:%@", ordername);
}

@end

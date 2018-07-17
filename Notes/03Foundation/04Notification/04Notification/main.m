//
//  main.m
//  04Notification
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"
#import "Nanny.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Baby *baby = [[Baby alloc] init];
        Nanny *nanny = [[Nanny alloc] initWithBaby:baby];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}

//
//  Animal.m
//  03KVO
//
//  Created by dfang on 2019-8-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import "Animal.h"

@implementation Animal

- (void)setName:(NSString *)name {
    _name = [name stringByAppendingString:@"-hhhh"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@的%@改变为%@", object, keyPath, change);
}

@end

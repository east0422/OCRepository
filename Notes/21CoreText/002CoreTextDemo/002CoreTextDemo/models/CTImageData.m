//
//  CTImageData.m
//  002CoreTextDemo
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "CTImageData.h"

@implementation CTImageData

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@, index:%ld, position:%@", _name, (long)_index, NSStringFromCGRect(_position)];
}

@end

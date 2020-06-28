//
//  CTLinkData.m
//  002CoreTextDemo
//
//  Created by dfang on 2020-6-25.
//  Copyright © 2020 east. All rights reserved.
//

#import "CTLinkData.h"

@implementation CTLinkData

- (NSString *)description
{
    return [NSString stringWithFormat:@"title:%@, url:%@, range:%@", _title, _url, NSStringFromRange(_range)];
}

@end

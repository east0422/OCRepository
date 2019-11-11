//
//  NSDate+Formatter.m
//  005UITableView
//
//  Created by dfang on 2019-11-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

+ (NSString *)currentDateString {
    return [[NSDate date] formatString];
}

- (NSString *)formatString {
    return [self convertWithFormat:@"YYYY-MM-dd HH:mm:ss"];
}

- (NSString *)convertWithFormat:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    return [formatter stringFromDate:self];
}

@end

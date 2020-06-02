//
//  SubNSURLProtocol.m
//  01WebviewJS
//
//  Created by dfang on 2020-5-28.
//  Copyright © 2020 east. All rights reserved.
//

#import "SubNSURLProtocol.h"

@implementation SubNSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"absoluteString:%@", request.URL.absoluteString);
    
    return YES;
}

@end

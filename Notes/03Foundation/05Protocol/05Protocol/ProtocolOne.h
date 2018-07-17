//
//  ProtocolOne.h
//  05Protocol
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProtocolOne <NSObject>

// 默认为required
- (void)test11;

@required
- (void)test12;

@optional
- (void)test13;

@end

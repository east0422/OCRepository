//
//  Restaurant.h
//  02RuntimeMsgForward
//  饭店
//  Created by dfang on 2020-5-25.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RestaurantProtocol <NSObject>

/** 下订单 */
- (void)order:(NSString *)ordername;

@end

@interface Restaurant : NSObject

@end

NS_ASSUME_NONNULL_END

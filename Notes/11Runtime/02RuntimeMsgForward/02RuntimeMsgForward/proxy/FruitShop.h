//
//  FruitShop.h
//  02RuntimeMsgForward
//  水果商店
//  Created by dfang on 2020-5-25.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FruitProtocol <NSObject>

/** 购买水果 */
- (void)buy:(NSString *)fruitName;

@end

@interface FruitShop : NSObject <FruitProtocol>

@end

NS_ASSUME_NONNULL_END

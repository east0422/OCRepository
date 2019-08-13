//
//  Person.h
//  03KVO
//
//  Created by dfang on 2019-8-7.
//  Copyright © 2019年 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject {
    @public
    NSString *nickName;
}

@property (nonatomic, strong) NSString *name;

-(void)setNickName: (NSString *)nickname;

@end

NS_ASSUME_NONNULL_END

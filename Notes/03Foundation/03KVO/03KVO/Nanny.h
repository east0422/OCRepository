//
//  Nanny.h
//  03KVO
//
//  Created by dfang on 2018-8-20.
//  Copyright © 2018年 east. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Baby;

@interface Nanny : NSObject {
    Baby *_baby;
}

- (id)initWithBaby:(Baby *)baby;

@end

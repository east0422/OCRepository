//
//  CTData.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTImageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *imageArr;

@end

NS_ASSUME_NONNULL_END

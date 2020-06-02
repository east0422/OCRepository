//
//  CTImageData.h
//  002CoreTextDemo
//
//  Created by dfang on 2020-5-13.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTImageData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger position;

/** 图片位置坐标是CoreText坐标系，需要转换为UIKit坐标系 */
@property (nonatomic, assign) CGRect imagePosition;

@end

NS_ASSUME_NONNULL_END

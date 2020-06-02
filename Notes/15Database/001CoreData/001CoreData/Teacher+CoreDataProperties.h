//
//  Teacher+CoreDataProperties.h
//  001CoreData
//
//  Created by dfang on 2020-6-1.
//  Copyright © 2020 east. All rights reserved.
//
//

#import "Teacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest;

@property (nonatomic) int32_t tid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t age;
@property (nonatomic) NSNumber *gender;

@end

NS_ASSUME_NONNULL_END

//
//  Teacher+CoreDataProperties.m
//  001CoreData
//
//  Created by dfang on 2020-6-1.
//  Copyright © 2020 east. All rights reserved.
//
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
}

@dynamic tid;
@dynamic name;
@dynamic age;
@dynamic gender;

@end

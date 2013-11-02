//
//  DHAnimal.h
//  DHCoreDataStack
//
//  Created by David Hardiman on 16/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DHAnimal : NSManagedObject

@property (nonatomic, retain) NSString * animalName;
@property (nonatomic, retain) NSString * animalType;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSNumber * height;

@end

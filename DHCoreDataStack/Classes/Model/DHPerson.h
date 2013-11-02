//
//  DHPerson.h
//  DHCoreDataStack
//
//  Created by David Hardiman on 16/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DHPerson : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * birthday;

@end

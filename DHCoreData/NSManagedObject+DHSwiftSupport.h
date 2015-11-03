//
//  NSManagedObject+DHPrivate.h
//  DHCoreDataStack
//
//  Created by Dave Hardiman on 02/11/2015.
//
//
@import CoreData;

@interface NSManagedObject (DHSwiftSupport)

+ (NSEntityDescription *)entityDescriptionForClassInContext:(NSManagedObjectContext *)context;

@end
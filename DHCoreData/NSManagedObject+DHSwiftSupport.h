//
//  NSManagedObject+DHPrivate.h
//  DHCoreDataStack
//
//  Created by Dave Hardiman on 02/11/2015.
//
//

@interface NSManagedObject (DHSwiftSupport)

+ (NSArray *)objectsInContext:(NSManagedObjectContext *)context
        sortedWithDescriptors:(NSArray *)sortDescriptors
            matchingPredicate:(id)stringOrPredicate
                    arguments:(va_list)args;

+ (instancetype)objectInContext:(NSManagedObjectContext *)context
          sortedWithDescriptors:(NSArray *)sortDescriptors
              matchingPredicate:(id)stringOrPredicate
                      arguments:(va_list)args;

@end
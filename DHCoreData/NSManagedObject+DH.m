//
//  NSManagedObject+DH.m
//  DHCoreDataStack
//
//  Created by David Hardiman on 09/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import "NSManagedObject+DH.h"

@implementation NSManagedObject (DH)

+ (NSEntityDescription *)entityDescriptionForClassInContext:(NSManagedObjectContext *)context {
    NSManagedObjectModel *model = context.persistentStoreCoordinator.managedObjectModel;
    __block NSEntityDescription *entity = nil;
    [model.entities enumerateObjectsUsingBlock:^(NSEntityDescription *testEntity, NSUInteger idx, BOOL *stop) {
        if ([testEntity.managedObjectClassName isEqualToString:NSStringFromClass(self)]) {
            entity = testEntity;
            *stop = YES;
        }
    }];
    return entity;
}

+ (instancetype)insertObjectInContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [self entityDescriptionForClassInContext:context];
    return [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:context];
}

+ (NSArray *)objectsInContext:(NSManagedObjectContext *)context
        sortedWithDescriptors:(NSArray *)sortDescriptors
            matchingPredicate:(id)stringOrPredicate
                    arguments:(va_list)args {
    NSFetchRequest *request = [self fetchRequestForContext:context
                                     sortedWithDescriptors:sortDescriptors
                                         matchingPredicate:stringOrPredicate
                                                 arguments:args];
    return [context executeFetchRequest:request error:nil];
}

+ (NSArray *)objectsInContext:(NSManagedObjectContext *)context sortedWithDescriptors:(NSArray *)sortDescriptors matchingPredicate:(id)stringOrPredicate, ... {
    va_list args;
    va_start(args, stringOrPredicate);
    NSArray *results = [self objectsInContext:context sortedWithDescriptors:sortDescriptors matchingPredicate:stringOrPredicate arguments:args];
    va_end(args);
    return results;
}

/*
 From http://www.cocoawithlove.com/2008/03/core-data-one-line-fetch.html
 */
+ (instancetype)objectInContext:(NSManagedObjectContext *)context matchingPredicate:(id)stringOrPredicate, ... {
    va_list args;
    va_start(args, stringOrPredicate);
    NSArray *results = [self objectsInContext:context sortedWithDescriptors:nil matchingPredicate:stringOrPredicate arguments:args];
    va_end(args);
    return [results lastObject];
}

#pragma mark - Fetch request
+ (NSFetchRequest *)fetchRequestForContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [self entityDescriptionForClassInContext:context];
    return [[NSFetchRequest alloc] initWithEntityName:entity.name];
}

+ (NSFetchRequest *)fetchRequestForContext:(NSManagedObjectContext *)context
                     sortedWithDescriptors:(NSArray *)sortDescriptors
                         matchingPredicate:(id)stringOrPredicate
                                 arguments:(va_list)args {
    NSFetchRequest *request = [self fetchRequestForContext:context];
    if (stringOrPredicate) {
        NSPredicate *predicate = [stringOrPredicate isKindOfClass:[NSPredicate class]] ? stringOrPredicate : nil;
        if (!predicate) {
            NSAssert([stringOrPredicate isKindOfClass:[NSString class]], @"Parameter should be an NSString or NSPredicate");
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate arguments:args];
        }
        request.predicate = predicate;
    }
    request.sortDescriptors = sortDescriptors;
    return request;
}

+ (NSFetchRequest *)fetchRequestForContext:(NSManagedObjectContext *)context
                     sortedWithDescriptors:(NSArray *)sortDescriptors
                         matchingPredicate:(id)stringOrPredicate, ... {
    va_list args;
    va_start(args, stringOrPredicate);
    NSFetchRequest *request = [self fetchRequestForContext:context
                                     sortedWithDescriptors:sortDescriptors
                                         matchingPredicate:stringOrPredicate
                                                 arguments:args];
    va_end(args);
    return request;
}

@end

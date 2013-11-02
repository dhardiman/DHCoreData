//
//  NSManagedObject+DH.h
//  DHCoreDataStack
//
//  Created by David Hardiman on 09/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

@interface NSManagedObject (DH)

/**
 Inserts a new entity in to the specified context
 @param context The context to insert in to
 */
+ (instancetype)insertObjectInContext:(NSManagedObjectContext *)context;

/**
 Finds an array of objects matching the specified predicate and sorted according to the supplid descriptors
 @param context The context to search in
 @param sortDescriptors Sort descriptor array
 @param stringOrPredicate Either an NSPredicate object or a string with variadic arguments to use to create a predicate
 */
+ (NSArray *)objectsInContext:(NSManagedObjectContext *)context
        sortedWithDescriptors:(NSArray *)sortDescriptors
            matchingPredicate:(id)stringOrPredicate, ...;

/**
 Finds an object matching the specified predicate
 @param context The context to search in
 @param stringOrPredicate Either an NSPredicate object or a string with variadic arguments to use to create a predicate
 */
+ (instancetype)objectInContext:(NSManagedObjectContext *)context
              matchingPredicate:(id)stringOrPredicate, ...;

/**
 *	Creates a fetch request for this class's entity
 *
 *	@param	context	Managed object context to use to configure the request
 *
 *	@return	Configured NSFetchRequest for this class's entity
 */
+ (NSFetchRequest *)fetchRequestForContext:(NSManagedObjectContext *)context;

/**
 *	Creates a fetch request for this class's entity with the provided sort descriptors and predicate
 *
 *	@param	context	Managed object context to use to configure the request
 *	@param	sortDescriptors	Sort descriptor array To sort the results on
 *	@param	stringOrPredicate Either an NSPredicate object or a string with variadic arguments to use to create a predicate
 *
 *	@return	Configured NSFetchRequest for this class's entity, with the provided sort descriptors and predicate
 */
+ (NSFetchRequest *)fetchRequestForContext:(NSManagedObjectContext *)context
                     sortedWithDescriptors:(NSArray *)sortDescriptors
                         matchingPredicate:(id)stringOrPredicate, ...;

@end

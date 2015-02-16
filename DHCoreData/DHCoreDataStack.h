//
//  DHCoreDataStack.h
//  DHCoreDataStack
//
//  Created by David Hardiman on 09/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 Class for vending the core data stack for the application.
 Users should use the shared instance or data may not get
 merged to the main context properly
 */
@interface DHCoreDataStack : NSObject

/**
 Shared instance of the stack
 */
+ (instancetype)sharedStack;

/**
 Name of the model we should be looking for
 */
@property (nonatomic, copy) NSString *modelName;

/**
 Name we should use for the store. Will default
 to model name if not set
 */
@property (nonatomic, copy) NSString *storeName;

/**
 Where should we store the database? Defaults to NSCachesDirectory,
 assuming this is just a cache of feeds. If changing to NSDocumentsDirectory
 ensure this database is only storing user created data
 */
@property (nonatomic, copy) NSString *directoryPath;

/**
 The main thread context for the application
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

/**
 Returns a configured managed object context for use in concurrent operations
 Will merge changes back to the main context
 */
- (NSManagedObjectContext *)context;

@end

//
//  DHCoreDataStack.h
//
//  Created by David Hardiman on 23/10/2012.
//

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
 The main thread context for the application
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

/**
 Returns a configured managed object context for use in concurrent operations
 Will merge changes back to the main context
 */
- (NSManagedObjectContext *)context;

@end

/**
 Category to save a context
 */
@interface NSManagedObjectContext (Saving)

/**
 Saves the context and also propagates saves to its parent
 */
- (BOOL)dhSave:(NSError **)error;

@end
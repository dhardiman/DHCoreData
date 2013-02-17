//
//  DHCoreDataStack.m
//
//  Created by David Hardiman on 23/10/2012.
//

#import "DHCoreDataStack.h"

@interface DHCoreDataStack ()
/**
 The parent managed object context, used to save changes concurrently
 */
@property (nonatomic, strong) NSManagedObjectContext *parentContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation DHCoreDataStack {
    NSManagedObjectContext *_mainContext;
}

- (id)init {
    if ((self = [super init])) {
        _directoryPath = NSCachesDirectory;
    }
    return self;
}

+ (instancetype)sharedStack {
    static DHCoreDataStack *sharedStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStack = [[self alloc] init];
    });
    return sharedStack;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSURL *cachesURL = [[[NSFileManager defaultManager]
                             URLsForDirectory:self.directoryPath inDomains:NSUserDomainMask] lastObject];
        NSString *storeName = self.storeName.length ? self.storeName : self.modelName;
        NSURL *storeURL = [cachesURL URLByAppendingPathComponent:storeName];
        NSDictionary *options = @{
            NSMigratePersistentStoresAutomaticallyOption : @YES,
            NSInferMappingModelAutomaticallyOption : @YES
        };
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:options
                                                               error:&error]) {
            NSLog(@"Error creating persistent store: %@", error);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainContext {
    if (!_mainContext) {
        self.parentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.parentContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setParentContext:self.parentContext];
    }
    return _mainContext;
}

- (NSManagedObjectContext *)context {
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [moc setParentContext:self.mainContext];
    return moc;
}

@end

@implementation NSManagedObjectContext (Save)

- (BOOL)dhSave:(NSError **)error {
    if (![self save:error]) {
        return NO;
    }
    
    [[self parentContext] performBlockAndWait:^{
        [[self parentContext] dhSave:error];
    }];
    
    return (&error == nil);
}

@end

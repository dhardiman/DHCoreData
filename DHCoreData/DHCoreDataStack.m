//
//  DHCoreDataStack.m
//  DHCoreDataStack
//
//  Created by David Hardiman on 09/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHCoreDataStack.h"
@import DHFoundation;
#import <objc/runtime.h>

@interface DHCoreDataStack ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *mainContext;
@end

@implementation DHCoreDataStack

- (id)init {
    if ((self = [super init])) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        _directoryPath = [[url path] copy];
    }
    return self;
}

+ (instancetype)sharedStack {
    @synchronized(self) {
        id sharedStack = objc_getAssociatedObject(self, (__bridge const void *)(self));
        if (!sharedStack) {
            sharedStack = [[self alloc] init];
            objc_setAssociatedObject(self, (__bridge const void *)(self), sharedStack, OBJC_ASSOCIATION_RETAIN);
        }
        return sharedStack;
    }
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
        NSString *storeName = self.storeName.length ? self.storeName : self.modelName;
        NSString *storePath = [self.directoryPath stringByAppendingPathComponent:storeName];
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
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
    NSAssert([NSThread isMainThread], @"mainContext should only be called from the main thread");
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _mainContext;
}

- (NSManagedObjectContext *)context {
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    NSManagedObjectContext *mainContext = self.mainContext;
    [moc.dh_notificationStore addObserverForName:NSManagedObjectContextDidSaveNotification object:moc usingBlock:^(NSNotification *note) {
        [mainContext performBlock:^{
            [mainContext mergeChangesFromContextDidSaveNotification:note];
        }];
    }];
    return moc;
}

@end

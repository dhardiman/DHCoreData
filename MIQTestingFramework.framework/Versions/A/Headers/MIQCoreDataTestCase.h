//
//  MIQCoreDataTestBase.h
//
//  Created by David Hardiman on 21/01/2011.
//  Copyright 2011 Mobile IQ. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 1

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/**
 Base class for Core Data testing
 */
@interface MIQCoreDataTestCase : XCTestCase
/**
 Context to use
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 Persistent store
 */
@property (nonatomic, strong) NSPersistentStore *store;

/**
 An array of instances of NSBundle to search. If nil,
 then the main bundle is searched. The model will be created
 by merging all the models found in given bundles.
 To override, you must set it before the call to setupCoreData.
 */
@property (nonatomic, strong) NSArray *modelBundles;

- (void)setupCoreData;

@end

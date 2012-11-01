//
//  DHCoreDataTestBase.m
//
//  Created by David Hardiman on 21/01/2011.
//

#import "DHCoreDataTestBase.h"


@implementation DHCoreDataTestBase {
    NSPersistentStoreCoordinator *_coord;
    NSManagedObjectModel *_model;
}
@synthesize persistentStoreCoordinator = _coord;

- (void)setupCoreData {
    _model = [NSManagedObjectModel mergedModelFromBundles: nil];
    _coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    _store = [_coord addPersistentStoreWithType:NSInMemoryStoreType
                                  configuration:nil
                                            URL:nil
                                        options:nil
                                          error:NULL];
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:_coord];
}

- (void)setUp {
    [super setUp];
    [self setupCoreData];
}

- (void)tearDown {
    _coord = nil;
    _managedObjectContext = nil;
    _model = nil;
    _store = nil;
    [super tearDown];
}

- (void)testThatEnvironmentWorks {
    expect(_model).toNot.beNil();
    STAssertNotNil(self.managedObjectContext, @"managed object context not created");
}

@end

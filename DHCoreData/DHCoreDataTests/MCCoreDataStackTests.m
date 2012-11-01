//
//  DHCoreDataStackTests.m
//
//  Created by David Hardiman on 23/10/2012.
//

#import "DHCoreDataStack.h"
#import "DHCoreDataTestBase.h"

@interface DHCoreDataStack ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

TEST_CASE_WITH_SUBCLASS(DHCoreDataStackTests, DHCoreDataTestBase) {
    DHCoreDataStack *_stack;
}

- (void)setUp {
    [super setUp];
    _stack = [[DHCoreDataStack alloc] init];
    _stack.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

- (void)testItIsPossibleToGetASharedCoreDataStack {
    DHCoreDataStack *stack = [DHCoreDataStack sharedStack];
    expect(stack).toNot.beNil();
    DHCoreDataStack *stack1 = [DHCoreDataStack sharedStack];
    expect(stack1).to.beIdenticalTo(stack);
}

- (void)testItIsPossibleToGetAMainThreadContext {
    NSManagedObjectContext *mainContext = _stack.mainContext;
    expect(mainContext).toNot.beNil();
}

- (void)testThereIsOnlyOneMainContext {
    NSManagedObjectContext *mainContext = _stack.mainContext;
    NSManagedObjectContext *otherMainContext = _stack.mainContext;
    expect(mainContext).to.beIdenticalTo(otherMainContext);
}

- (void)testTheMainContextHasMainThreadConcurrencyType {
    expect([_stack.mainContext concurrencyType] == NSMainQueueConcurrencyType).to.beTruthy();
}

- (void)testTheMainContextHasParentContext {
    NSManagedObjectContext *context = _stack.mainContext;
    expect([context parentContext]).toNot.beNil();
}

- (void)testTheMainContextParentHasAPersistentStoreCoordinatorAndAModel {
    NSManagedObjectContext *context = [_stack.mainContext parentContext];
    expect([context persistentStoreCoordinator]).toNot.beNil();
    expect([[context persistentStoreCoordinator] managedObjectModel]).toNot.beNil();
}

- (void)testThatItsPossibleToGetAPrivateQueueContext {
    NSManagedObjectContext *context = [_stack context];
    expect(context).toNot.beNil();
    expect([context concurrencyType] == NSPrivateQueueConcurrencyType).to.beTruthy();
    expect([context persistentStoreCoordinator]).toNot.beNil();
    expect([[context persistentStoreCoordinator] managedObjectModel]).toNot.beNil();
    expect([context parentContext]).to.beIdenticalTo(_stack.mainContext);
}

- (void)testThatChangesMadeOnAChildContextGetReflectedInTheParent {
    //TODO: Text existing state of context
    NSManagedObjectContext *context = [_stack context];
    __block NSError *error = nil;
    [context performBlockAndWait:^{
        //TODO: Create an entity and save
        [context dhSave:&error];
    }];
    //TODO: Test saved entities are in the parent context
}

END_TEST_CASE

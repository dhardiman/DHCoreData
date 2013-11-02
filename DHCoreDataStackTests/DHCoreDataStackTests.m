//
//  DHCoreDataStackTests.m
//  DHCoreDataStackTests
//
//  Created by David Hardiman on 09/07/2013.
//

#import <MIQTestingFramework/MIQTestingFramework.h>
#import "DHCoreDataStack.h"
#import "DHPerson.h"

@interface DHCoreDataStack ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

TEST_CASE_WITH_SUBCLASS(DHCoreDataStackTests, MIQCoreDataTestBase) {
    DHCoreDataStack *_stack;
}

- (void)setUp {
    [super setUp];
    _stack = [[DHCoreDataStack alloc] init];
    _stack.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

Test(ItIsPossibleToGetASharedCoreDataStack) {
    DHCoreDataStack *stack = [DHCoreDataStack sharedStack];
    expect(stack).toNot.beNil();
    DHCoreDataStack *stack1 = [DHCoreDataStack sharedStack];
    expect(stack1).to.beIdenticalTo(stack);
}

Test(ItIsPossibleToGetAMainThreadContext) {
    NSManagedObjectContext *mainContext = _stack.mainContext;
    expect(mainContext).toNot.beNil();
}

Test(ThereIsOnlyOneMainContext) {
    NSManagedObjectContext *mainContext = _stack.mainContext;
    NSManagedObjectContext *otherMainContext = _stack.mainContext;
    expect(mainContext).to.beIdenticalTo(otherMainContext);
}

Test(TheMainContextHasMainThreadConcurrencyType) {
    expect([_stack.mainContext concurrencyType] == NSMainQueueConcurrencyType).to.beTruthy();
}

Test(TheMainContextHasAPersistentStoreCoordinatorAndAModel) {
    NSManagedObjectContext *context = _stack.mainContext;
    expect([context persistentStoreCoordinator]).toNot.beNil();
    expect([[context persistentStoreCoordinator] managedObjectModel]).toNot.beNil();
}

Test(ThatItsPossibleToGetAPrivateQueueContext) {
    NSManagedObjectContext *context = [_stack context];
    expect(context).toNot.beNil();
    expect([context concurrencyType] == NSPrivateQueueConcurrencyType).to.beTruthy();
    expect([context persistentStoreCoordinator]).toNot.beNil();
    expect([context persistentStoreCoordinator]).to.beIdenticalTo([_stack.mainContext persistentStoreCoordinator]);
}

Test(ChangesMadeOnAChildContextGetReflectedInTheMainContext) {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *results = [_stack.mainContext executeFetchRequest:request error:nil];
    expect(results).to.haveCountOf(0);
    
    NSManagedObjectContext *context = [_stack context];
    DHPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    person.firstName = @"First name";
    person.lastName = @"Last name";
    [context save:nil];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName == %@ && lastName == %@", person.firstName, person.lastName];
    request.predicate = predicate;
    results = [_stack.mainContext executeFetchRequest:request error:nil];
    expect(results).to.haveCountOf(1);
    DHPerson *mainPerson = results[0];
    expect(mainPerson.firstName).to.equal(@"First name");
    
    person.firstName = @"Test Name";
    [context save:nil];
    expect(mainPerson.firstName).will.equal(@"Test Name");
}

END_TEST_CASE
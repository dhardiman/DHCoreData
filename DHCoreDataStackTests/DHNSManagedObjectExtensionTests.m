//
//  DHNSManagedObjectExtensionTests.m
//  DHCoreDataStack
//
//  Created by David Hardiman on 09/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//
#import <MIQTestingFramework/MIQTestingFramework.h>
#import "DHPerson.h"
#import "DHAnimal.h"
#import "NSManagedObject+DH.h"

TEST_CASE_WITH_SUBCLASS(DHNSManagedObjectExtensionTests, MIQCoreDataTestBase)

Test(ItIsPossibleToInsertANewEntity) {
    DHPerson *person = [DHPerson insertObjectInContext:self.managedObjectContext];
    expect(person).to.beKindOf([DHPerson class]);
    expect(person.entity.name).to.equal(@"Person");
    expect(person.managedObjectContext).to.equal(self.managedObjectContext);
}

Test(ItIsPossibleToInsertAnEntityOfAnotherType) {
    DHAnimal *animal = [DHAnimal insertObjectInContext:self.managedObjectContext];
    expect(animal).to.beKindOf([DHAnimal class]);
    expect(animal.entity.name).to.equal(@"Animal");
    expect(animal.managedObjectContext).to.equal(self.managedObjectContext);
}

Test(ItIsPossibleToFetchAnEntityMatchingAPredicate) {
    DHPerson *person1 = [DHPerson insertObjectInContext:self.managedObjectContext];
    person1.firstName = @"Test 1";
    person1.lastName = @"Test 2";
    DHPerson *person2 = [DHPerson objectInContext:self.managedObjectContext matchingPredicate:@"firstName == %@", @"Test 1"];
    expect(person2).to.equal(person1);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastName == %@", @"Test 2"];
    DHPerson *person3 = [DHPerson objectInContext:self.managedObjectContext matchingPredicate:predicate];
    expect(person3).to.equal(person1);
}

#define MAKE_SOME_PEOPLE \
    DHPerson *person1 = [DHPerson insertObjectInContext:self.managedObjectContext]; \
    person1.firstName = @"Person 1"; \
    person1.lastName = @"Surname 1"; \
    DHPerson *person2 = [DHPerson insertObjectInContext:self.managedObjectContext]; \
    person2.firstName = @"Person 2"; \
    person2.lastName = @"Surname 2"; \
    DHPerson *person3 = [DHPerson insertObjectInContext:self.managedObjectContext]; \
    person3.firstName = @"Fish"; \
    person3.lastName = @"Cake";

Test(ItIsPossibleToFetchAGroupOfObjects) {
    MAKE_SOME_PEOPLE;
    NSArray *array = [DHPerson objectsInContext:self.managedObjectContext sortedWithDescriptors:nil matchingPredicate:nil];
    expect(array).to.haveCountOf(3);
    array = [DHPerson objectsInContext:self.managedObjectContext sortedWithDescriptors:nil matchingPredicate:@"firstName == %@", @"Person 1"];
    expect(array).to.haveCountOf(1);
    array = [DHPerson objectsInContext:self.managedObjectContext sortedWithDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:NO]] matchingPredicate:nil];
    expect(array).to.haveCountOf(3);
    expect(array[0]).to.equal(person2);
    expect(array[1]).to.equal(person1);
    expect(array[2]).to.equal(person3);
    array = [DHPerson objectsInContext:self.managedObjectContext sortedWithDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:NO]] matchingPredicate:@"firstName BEGINSWITH %@", @"Person"];
    expect(array).to.haveCountOf(2);
    expect(array[0]).to.equal(person2);
    expect(array[1]).to.equal(person1);
}

Test(ItIsPossibleToCreateAFetchRequest) {
    MAKE_SOME_PEOPLE;
    NSFetchRequest *request = [DHPerson fetchRequestForContext:self.managedObjectContext];
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:nil];
    expect(array).to.haveCountOf(3);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName == %@", @"Person 1"];
    request = [DHPerson fetchRequestForContext:self.managedObjectContext sortedWithDescriptors:nil matchingPredicate:predicate];
    array = [self.managedObjectContext executeFetchRequest:request error:nil];
    expect(array).to.haveCountOf(1);
    request = [DHPerson fetchRequestForContext:self.managedObjectContext sortedWithDescriptors:nil matchingPredicate:@"firstName == %@", @"Person 1"];
    array = [self.managedObjectContext executeFetchRequest:request error:nil];
    expect(array).to.haveCountOf(1);
    request = [DHPerson fetchRequestForContext:self.managedObjectContext sortedWithDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:NO]] matchingPredicate:@"firstName BEGINSWITH %@", @"Person"];
    array = [self.managedObjectContext executeFetchRequest:request error:nil];
    expect(array).to.haveCountOf(2);
    expect(array[0]).to.equal(person2);
    expect(array[1]).to.equal(person1);
}

Test(ItIsPossibleToGetASinglePersonBasedOnOrder) {
    MAKE_SOME_PEOPLE;
    DHPerson *testPerson = [DHPerson objectInContext:self.managedObjectContext sortedWithDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:NO]] matchingPredicate:nil];
    expect(testPerson).to.equal(person2);
}

Test(ItIsPossibleToGetACountOfObjectsMatchingAParticularPredicate) {
    MAKE_SOME_PEOPLE;
    NSUInteger allPeople = [DHPerson countOfObjectsInContext:self.managedObjectContext matchingPredicate:nil];
    expect(allPeople).to.equal(3);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName == %@", @"Person 1"];
    NSUInteger thatGuy = [DHPerson countOfObjectsInContext:self.managedObjectContext matchingPredicate:predicate];
    expect(thatGuy).to.equal(1);
}

END_TEST_CASE

//
//  DHManagedObjectUpdatingTests.m
//  DHCoreDataStack
//
//  Created by David Hardiman on 16/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//
#import <MIQTestingFramework/MIQTestingFramework.h>
#import <DHFoundation/DHFoundation.h>
#import "DHPerson.h"
#import "DHAnimal.h"

TEST_CASE_WITH_SUBCLASS(DHManagedObjectUpdatingTests, MIQCoreDataTestBase)

Test(ItIsPossibleToUpdateObjectFromDictionary) {
    DHPerson *person = [DHPerson insertObjectInContext:self.managedObjectContext];
    NSDictionary *dictionary = @{
        @"firstName" : @"Test 1",
        @"lastName" : @"Test 2",
        @"age" : @33,
        @"birthday" : @"1980-01-29"
    };
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    [person updateValuesFromDictionary:dictionary dateFormatter:formatter];
    expect(person.firstName).to.equal(@"Test 1");
    expect(person.lastName).to.equal(@"Test 2");
    expect(person.age).to.equal(@33);
    NSDate *date = [formatter dateFromString:@"1980-01-29"];
    expect(person.birthday).to.equal(date);
}

Test(ItIsPossibleToUpdateObjectsFromDictionaryMatchingUpWithProvidedKeys) {
    DHAnimal *animal = [DHAnimal insertObjectInContext:self.managedObjectContext];
    NSDictionary *dictionary = @{
        @"animal_type" : @"Cat",
        @"animal_name" : @"Tibbles"
    };
    [animal updateValuesFromDictionary:dictionary dateFormatter:nil];
    expect(animal.animalType).to.equal(@"Cat");
    expect(animal.animalName).to.equal(@"Tibbles");
}

Test(ItIsPossibleToUpdateItemsBeyondTheTopLevelOfTheDictionaryPassedIn) {
    DHAnimal *animal = [DHAnimal insertObjectInContext:self.managedObjectContext];
    NSDictionary *dictionary = @{
        @"size" : @{
            @"height": @3,
            @"length" : @4
        }
    };
    [animal updateValuesFromDictionary:dictionary dateFormatter:nil];
    expect(animal.length).to.equal(@4);
    expect(animal.height).to.equal(@3);
}

Test(ItHandlesNullCorrectly) {
    DHAnimal *animal = [DHAnimal insertObjectInContext:self.managedObjectContext];
    animal.animalName = @"Trevor";
    NSDictionary *dictionary = @{
        @"animal_name" : NSNull.null
    };
    [animal updateValuesFromDictionary:dictionary dateFormatter:nil];
    expect(animal.animalName).to.beNil();
}

Test(ItIsPossibleToInsertAnObjectAndUpdateAllAtTheSameTime) {
    NSDictionary *dictionary = @{
        @"animal_type" : @"Cat",
        @"animal_name" : @"Tibbles"
    };
    DHAnimal *animal = [DHAnimal insertObjectWithDictionary:dictionary inContext:self.managedObjectContext dateFormatter:nil];
    expect(animal).to.beKindOf([DHAnimal class]);
    expect(animal.animalType).to.equal(@"Cat");
    expect(animal.animalName).to.equal(@"Tibbles");
}

Test(ItIsPossibleToInsertAnObjectAndUpdateWithoutNilingUnsetValues) {
    DHAnimal *animal = [DHAnimal insertObjectInContext:self.managedObjectContext];
    animal.animalName = @"🐍";
    animal.animalType = @"snake";
    [animal updateValuesFromDictionary:@{ @"animal_name": @"🐴" } dateFormatter:nil];
    expect(animal.animalType).to.beNil();
    
    animal.animalType = @"raptor";
    [animal updateValuesFromDictionary:@{ @"animal_name": @"🐴" } dateFormatter:nil nilUnsetValues:NO];
    expect(animal.animalType).notTo.beNil();
}

Test(ItIsPossibleToGetAListOfKeysThatWillBeUpdatedIfWeUpdateValuesFromDictionary) {
    DHAnimal *animal = [DHAnimal insertObjectInContext:self.managedObjectContext];
    animal.animalName = @"🐍";
    animal.animalType = @"snake";
    [animal updateValuesFromDictionary:@{ @"animal_name": @"🐴" } dateFormatter:nil];
    expect(animal.animalType).to.beNil();
    
    NSDictionary *newData = @{ @"animal_name": @"🐒" };
    NSArray *keys = [animal updatedKeysForDictionary:newData];
    NSString *updatedKey = keys.firstObject;
    expect([updatedKey isEqualToString:newData.allKeys.firstObject]).to.beTruthy();
}

Test(ItIsPossibleToUpdateAnObjectTransformingAnInputArrayIntoAString) {
    DHAnimal *animal = [DHAnimal insertObjectInContext:self.managedObjectContext];
    animal.animalType = @"🐊";
    animal.animalName = @"Crocs";
    NSArray *newName = @[ @"Croc", @"Joe" ];
    NSString *jsonString = [newName JSONString];
    [animal updateValuesFromDictionary:@{ @"animal_name": newName } dateFormatter:nil];
    expect(animal.animalName).to.equal(jsonString);
}

Test(ItIsPossibleToUpdateAnObjectTransformingAnInputDictionaryIntoAString) {
    DHAnimal *animal = [DHAnimal insertObjectInContext:self.managedObjectContext];
    animal.animalType = @"🐓";
    animal.animalName = @"Cock";
    NSDictionary *newName = @{ @"name": @"cockerel" };
    NSString *jsonString = [newName JSONString];
    [animal updateValuesFromDictionary:@{ @"animal_name": newName } dateFormatter:nil];
    expect(animal.animalName).to.equal(jsonString);
}

END_TEST_CASE

@implementation DHAnimal (Keys)

+ (NSDictionary *)keyPathsForProperties {
    return @{
        @"animalType" : @"animal_type",
        @"animalName" : @"animal_name",
        @"height" : @"size.height",
        @"length" : @"size.length"
    };
}

@end

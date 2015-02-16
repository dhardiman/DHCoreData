//
//  NSManagedObject+SetValuesFromDictionary.h
//  DHCoreData
//
//  Created by David Hardiman on 29/06/2011.
//  Copyright 2011 David Hardiman. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 *  NSManagedObject extension methods for easily updating an object from
 *  a dictionary representation
 */
@interface NSManagedObject (SetValuesFromDictionary)

/**
 Takes a dictionary and populates the object with values from that dictionary.
 Assumes that dictionary keys are the same as the object's property names unless keyPathsForProperties returns
 a non-nil dictionary
 @param dictionary The non-nil dictionary with the values to update from
 @param formatter Date formatter to use for date values or nil if dates are either integer values or not expected
 */
- (void)updateValuesFromDictionary:(NSDictionary *)dictionary
                     dateFormatter:(NSDateFormatter *)formatter;

/**
 As above, but allows you to specify whether keys not found in the update dictionary
 should be nil'd out on the managed object or not. If not, they will be left as before the update.
 @param dictionary The non-nil dictionary with the values to update from
 @param formatter Date formatter to use for date values or nil if dates are either integer values or not expected
 @param nilUnset Sets whether we should we nil the managed object's values if not found in the dictionary.
 */
- (void)updateValuesFromDictionary:(NSDictionary *)dictionary
                     dateFormatter:(NSDateFormatter *)formatter
                    nilUnsetValues:(BOOL)nilUnset;

/**
 Returns the keys of the dictionary passed in that contain
 different data than that in the managed object.
 @param dictionary The dictionary to check
 */
- (NSArray *)updatedKeysForDictionary:(NSDictionary *)dictionary;

/**
 Inserts an object to the specified context and popuplates it with the provided dictionary. Does not attempt to unique
 the object, so ensure this is done prior to this call.
 @param dictionary The non-nil dictionary with the values to update from
 @param context The managed object context to insert to
 @param formatter Date formatter to use for date values or nil if dates are either integer values or not expected
 */
+ (instancetype)insertObjectWithDictionary:(NSDictionary *)dictionary
                                 inContext:(NSManagedObjectContext *)context
                             dateFormatter:(NSDateFormatter *)formatter;

/**
 Overrideable dictionary of keys to map
 properties to. If not overridden, returns nil
 and properties are assumed to be the same name
 as keys in the provided dictionary.
 */
+ (NSDictionary *)keyPathsForProperties;

@end

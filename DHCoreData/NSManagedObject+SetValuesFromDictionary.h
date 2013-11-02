//
//  NSManagedObject+SetValuesFromDictionary.h
//  DHCoreData
//
//  Created by David Hardiman on 29/06/2011.
//  Copyright 2011 David Hardiman. All rights reserved.
//

#import <Foundation/Foundation.h>

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

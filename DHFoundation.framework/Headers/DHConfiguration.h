//
//  DHConfiguration.h
//  DHFoundation
//
//  Created by David Hardiman on 15/09/2013.
//  Copyright (c) 2012 David Hardiman. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 Base class for retrieving properties from a config file.
 Supports properties of types supported by plist (NSNumber, NSString, NSDictionary, NSArray),
 as well as conversions to BOOL, NSInteger and float. For other conversions,
 use the extension functionality documented below.
 */
@interface DHConfiguration : NSObject

/**
 Shared instance of the configuration
 */
+ (instancetype)sharedConfiguration;

/**
 Name of the config file to use as a data source.
 Defaults to "Config". Override getter in subclass.
 */
@property (nonatomic, readonly) NSString *configFileName;

/**
 Optional prefix for properties in the config file.
 This class will check for the property name first,
 and if not found will capitalise the first letter of
 the property and add this prefix and try again.
 */
@property (nonatomic, copy) NSString *propertyPrefix;

/**
 Clears the config dictionary for reloading
 */
- (void)reloadConfig;

/**
 Override if the dictionary to be used for the config isn't just
 a plist dictionary
 
 @return Loaded dictionary
 */
- (NSDictionary *)loadDictionary;

/**
 Function used by all extended methods for fetching an object value from
 the underlying config dictionary. Can be called by method extensions if
 other object types need to be added.
 
 @param self The DHConfiguration instance making the call
 @param _cmd The SEL being called on the instance
 
 @return The object discovered in the underlying dictionary
 */
id dh_objectGetter(DHConfiguration *self, SEL _cmd);

/**
 For subclasses, override this method and check the type to see if
 it's a type that can be supported. In this method, if the type is
 supported, use class_addMethod to add the instance method.
 
 @param sel The selector being resolved
 @param type The type of the discovered property
 
 @return YES if the method was resolved and added, NO if not supported
 */
+ (BOOL)canResolveInstanceMethod:(SEL)sel forType:(const char *)type;

@end
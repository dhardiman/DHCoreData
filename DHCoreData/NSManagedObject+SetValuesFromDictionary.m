//
//  NSManagedObject+SetValuesFromDictionary.m
//  DHCoreData
//
//  Created by David Hardiman on 29/06/2011.
//  Copyright 2011 David Hardiman. All rights reserved.
//

#import "NSManagedObject+SetValuesFromDictionary.h"
#import <DHFoundation/DHFoundation.h>
#import "NSDate+Rails.h"
#import "NSManagedObject+DH.h"
#import "NSObject+Cast.h"

typedef id (^DHValueTransformBlock)(id value, NSDateFormatter *formatter);
@interface DHValueTransformer : NSValueTransformer
@property (nonatomic, copy) DHValueTransformBlock transform;
@property (nonatomic, weak) NSDateFormatter *formatter;
+ (void)addTransformerForName:(NSString *)name withBlock:(DHValueTransformBlock)block;
@end

@implementation NSManagedObject (SetValuesFromDictionary)

+ (NSDictionary *)keyPathsForProperties {
    return nil;
}

+ (void)addTransformers {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DHValueTransformer addTransformerForName:[self attributeNameFromAttributeType:NSStringAttributeType] withBlock:^id(id value, NSDateFormatter *formatter) {
            if ([value isKindOfClass:[NSNumber class]]) {
                //We want a string, but we've got a number, so convert
                return [value stringValue];
            }
            if ([value conformsToProtocol:@protocol(NSFastEnumeration)]) {
                // We want a string, but we've got an array or dictionary. Convert to JSON.
                return [value JSONString];
            }
            return value;
        }];
        [DHValueTransformer addTransformerForName:[self attributeNameFromAttributeType:NSInteger16AttributeType] withBlock:^id(id value, NSDateFormatter *formatter) {
            if ([value isKindOfClass:[NSString class]]) {
                //We want a number, but we've got a string, so try to convert
                return @([value integerValue]);
            }
            return value;
        }];
        [DHValueTransformer addTransformerForName:[self attributeNameFromAttributeType:NSFloatAttributeType] withBlock:^id(id value, NSDateFormatter *formatter) {
            if ([value isKindOfClass:[NSString class]]) {
                //We want a float but we've got a string, so try to convert
                return @([value doubleValue]);
            }
            return value;
        }];
        [DHValueTransformer addTransformerForName:[self attributeNameFromAttributeType:NSDateAttributeType] withBlock:^id(id value, NSDateFormatter *formatter) {
            if ([value isKindOfClass:[NSString class]]) {
                return [NSDate dateFromString:[value description]
                                withFormatter:formatter];
            }
            if ([value isKindOfClass:[NSNumber class]]) {
                return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
            }
            return value;
        }];
    });
}

+ (NSString *)attributeNameFromAttributeType:(NSAttributeType)type {
    switch (type) {
        case NSDateAttributeType:
            return @"DateTransformer";
        case NSStringAttributeType:
            return @"StringTransformer";
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
        case NSBooleanAttributeType:
            return @"NumberTransformer";
        case NSDoubleAttributeType:
        case NSFloatAttributeType:
            return @"FloatTransformer";
        default:
            return nil;
    }
}

/*
 This method is heavily inspired by this blog post: http://www.cimgf.com/2011/06/02/saving-json-to-core-data/
 */
- (void)updateValuesFromDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)formatter {
    [self updateValuesFromDictionary:dictionary dateFormatter:formatter nilUnsetValues:YES];
}

- (void)updateValuesFromDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)formatter nilUnsetValues:(BOOL)nilUnset {
    if (!dictionary) {
        // No dictionary so return
        return;
    }
    
    [NSManagedObject addTransformers];
    
    NSDictionary *attributes = [[self entity] attributesByName];
    NSDictionary *keyMap = [[self class] keyPathsForProperties];
    [attributes enumerateKeysAndObjectsUsingBlock:^(NSString *attribute, id obj, BOOL *stop) {
        NSString *dataKey = keyMap ? keyMap[attribute] : attribute;
        if (!dataKey) {
            //We've not been passed this key in the map, so ignore
            return;
        }
        id value = [dictionary valueForKeyPath:dataKey];
        if (!nilUnset && value == nil) {
            return;
        }
        if (nilUnset && (!value || value == [NSNull null])) {
            // We don't have a value for this field, so clear it
            // and move on
            [self setValue:nil forKey:attribute];
            return;
        }
        NSAttributeType attributeType = [attributes[attribute] attributeType];
        NSString *transformerName = [NSManagedObject attributeNameFromAttributeType:attributeType];
        DHValueTransformer *transformer = [DHValueTransformer cast:[NSValueTransformer valueTransformerForName:transformerName]];
        transformer.formatter = formatter;
        value = [transformer transformedValue:value];
        
        /**
         Is the new value the same as the old value?
         Core data counts setting a value as a saveable
         change, even if the data is identical. Doing
         this check saves unnecessary object saves.
         */
        if (![[self valueForKey:attribute] isEqual:value]) {
            [self setValue:value forKey:attribute];
        }
    }];
}

- (NSArray *)updatedKeysForDictionary:(NSDictionary *)dictionary {
    NSDictionary *keyMap = [[self class] keyPathsForProperties];
    NSMutableArray *updatedKeys = [[NSMutableArray alloc] init];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSUInteger keyPosition = [keyMap.allValues indexOfObject:key];
        if (keyPosition != NSNotFound) {
            NSString *propertyName = keyMap.allKeys[keyPosition];
            if ([self respondsToSelector:NSSelectorFromString(propertyName)] && ![[self valueForKey:propertyName] isEqual:obj]) {
                [updatedKeys addObject:key];
            }
        }
        
    }];
    return updatedKeys;
}

+ (instancetype)insertObjectWithDictionary:(NSDictionary *)dictionary
                                 inContext:(NSManagedObjectContext *)context
                             dateFormatter:(NSDateFormatter *)formatter {
    id object = [self insertObjectInContext:context];
    [object updateValuesFromDictionary:dictionary dateFormatter:formatter];
    return object;
}

@end

@implementation DHValueTransformer

- (id)transformedValue:(id)value {
    if (self.transform) {
        return self.transform(value, self.formatter);
    }
    return nil;
}

+ (void)addTransformerForName:(NSString *)name withBlock:(DHValueTransformBlock)block {
    DHValueTransformer *transformer = [[DHValueTransformer alloc] init];
    transformer.transform = block;
    [NSValueTransformer setValueTransformer:transformer forName:name];
}

@end

//
//  NSObject+JSONSerialise.h
//  DHFoundation
//
//  Created by David Hardiman on 27/09/2012.
//  Copyright (c) 2012 David Hardiman. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 *  Convenience category to wrap `NSJSONSerialization` to serialise an
 *  object to json
 */
@interface NSObject (JSONSerialise)

/**
 Serialise the object to a JSON string
 */
- (NSString *)JSONString;

/**
 Serialise the object to the data representaiton
 of a JSON string
 */
- (NSData *)JSONData;

@end

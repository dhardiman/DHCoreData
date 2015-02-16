//
//  NSCache+Subscripting.h
//  DHFoundation
//
//  Created by David Hardiman on 17/06/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 Adds subscripting support to NSCache
 */
@interface NSCache (Subscripting)

/**
 Return a value for the subscript key
 @param key The key to look for
 */
- (id)objectForKeyedSubscript:(id)key;

/**
 Set a value for the subscript key
 @param obj The object to store
 @param key The key to store against
 */
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end

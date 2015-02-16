//
//  NSObject+Cast.h
//  DHFoundation
//
//  Created by David Hardiman on 19/08/2012.
//
#import <Foundation/Foundation.h>

/**
 From https://gist.github.com/3391903
 */
@interface NSObject (Cast)

/**
 Safely cast an object
 Tests if the from parameter is of
 the correct type and returns nil
 if not.
 @usage [DHTestClass cast:myObject]
 @param from The object to cast
 */
+ (instancetype)cast:(id)from;

@end
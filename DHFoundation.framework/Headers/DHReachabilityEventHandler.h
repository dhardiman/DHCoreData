//
//  DHReachabilityEventHandler.h
//  DHFoundation
//
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHReachability.h"

/**
 *  Block executed when reachability status changes
 *
 *  @param status The new status
 */
typedef void (^DHReachabilityChanged)(DHReachabilityStatus status);

/**
 *  Object used to be alerted for reachability status changes
 */
@interface DHReachabilityEventHandler : NSObject

/**
 Block callback for reachability changed notifications
 */
@property (nonatomic, copy) DHReachabilityChanged changed;

/**
 *  The reachability object being used
 */
@property (nonatomic, readonly, strong) DHReachability *reachability;

@end

/**
 *  Convenience category to allow easy access to a reachability event handler
 */
@interface NSObject (Reachability)

/**
 Returns the reachability handler
 */
@property (nonatomic, strong, readonly) DHReachabilityEventHandler *dh_reachability;

@end
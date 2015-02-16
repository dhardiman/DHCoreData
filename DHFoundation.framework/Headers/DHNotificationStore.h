//
//  DHNotificationStore.h
//
//  Created by Sebastian Skuse on 26/02/2013.
//  Copyright (c) 2013 Seb Skuse. All rights reserved.
//

/* From https://github.com/sebskuse/SCSNotificationStore
 Copyright (c) 2013 Seb Skuse (http://seb.skus.es/)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <Foundation/Foundation.h>

/**
 *  A block that will be executed when a notification is received
 *
 *  @param note The notification object posted
 */
typedef void (^DHNotificationStoreBlock)(NSNotification *note);

/**
 An object for making `NSNotificationCenter`'s block APIs a little easier
 to deal with by automatically handling the observer objects returned.
 
 NOTE: There is no need to store and remove the notification objects 
 externally. this is handled for you automatically in this class. 
 Return values should be used for removeObserver: purposes only
 when you need to remove the observer before the owner of this object
 gets deallocated.
 */
@interface DHNotificationStore : NSObject

/**
 Add a notification with specified name, on the posting queue with
 a nil object with the specified callback block.
 @param name The name of the notification
 @param block the callback block to use
 @return the notification
 */
- (id)addObserverForName:(NSString *)name usingBlock:(DHNotificationStoreBlock)block;

/**
 Add a notification with specified name, on the posting queue with
 a nil object with the specified callback block.
 @param name The name of the notification
 @param obj The object to use
 @param block the callback block to use
 @return the notification
 */
- (id)addObserverForName:(NSString *)name object:(id)obj usingBlock:(DHNotificationStoreBlock)block;

/**
 Add an observer for events with the specified names, on the posting queue with
 a nil object with the specified callback block.
 @param names Array of the names of the notifications to observe
 @param block the callback block to use
 @return the notifications
 */
- (NSArray *)addObserversForNames:(NSArray *)names usingBlock:(DHNotificationStoreBlock)block;

/**
 Add a notification with specified name, specified queue
 with a nil object and the specified callback block.
 @param name The name of the notification
 @param queue the queue to add the notification listener to
 @param block the callback block to use
 @return the notification
 */
- (id)addObserverForName:(NSString *)name queue:(NSOperationQueue *)queue usingBlock:(DHNotificationStoreBlock)block;

/**
 Add an observer for events with the specified names, on the specified queue with
 a nil object with the specified callback block.
 @param names Array of the names of the notifications to observe
 @param queue the queue to add the notification listener to
 @param block the callback block to use
 @return the notifications
 */
- (NSArray *)addObserversForNames:(NSArray *)names queue:(NSOperationQueue *)queue usingBlock:(DHNotificationStoreBlock)block;

/**
 Add a notification
 @param name The name of the notification
 @param obj The object to use
 @param queue the queue to add the notification listener to
 @param block the callback block to use
 @return the notification
 */
- (id)addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(DHNotificationStoreBlock)block;

/**
 Add an observer for events with the specified names, on the specified queue with
 a nil object with the specified callback block.
 @param names Array of the names of the notifications to observe
 @param obj The object to use
 @param queue the queue to add the notification listener to
 @param block the callback block to use
 @return the notifications
 */
- (NSArray *)addObserversForNames:(NSArray *)names object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(DHNotificationStoreBlock)block;

/**
 Allow access to the underlying notification observer dictionary.
 @param aKey The notification name being requested
 @return array of notification observer objects for given key name.
 */
- (id)objectForKeyedSubscript:(id)aKey;

/**
 Remove an observer from NotificationCenter & the object store.
 @param observer the observer object to remove
 */
- (void)removeObserver:(id)observer;

/**
 Remove all observers from NotificationCenter & the object store
 that are for the specified name
 @param name of the notification
 */
- (void)removeObserversForName:(NSString *)name;

/**
 Removes all observers from NotificationCenter & the object store
 */
- (void)removeAllObservers;

@end

//
//  NSObject+Notifications.h
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
#import "DHNotificationStore.h"

/**
 *  Convenience category to make it easy to use `NSNotificationCenter`'s
 *  block methods
 */
@interface NSObject (Notifications)

/**
 Returns the block notification store associated with this object.
 */
@property (atomic, strong, readonly) DHNotificationStore *dh_notificationStore;

@end

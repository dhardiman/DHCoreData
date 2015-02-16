//
//  NSDate+Rails.h
//  DHFoundation
//
//  Copyright 2010 David Hardiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Category which adds various date utility functions; heavily inspired by Rails.
 @see http://api.rubyonrails.org/
 */
@interface NSDate (Rails)

/**
 Internal method used to split out date components. Useful for date comparison.
 */
- (NSDateComponents *)gregorianCalendarComponents;

/**
 Returns YES if this date is after the specified date, otherwise NO.
 @param other The other date to compare
 */
- (BOOL)isAfter:(NSDate *)other;

/**
 Returns YES If this date is before the specified date, otherwise NO.
 @param other The other date to compare
 */
- (BOOL)isBefore:(NSDate *)other;

/**
 Returns YES if this date represents a date that is less than 1 hour old, otherwise NO. The current time is treated as
 whatever is returned by [NSDate date].
 */
- (BOOL)isInLastHour;

/**
 Returns YES if this date represents a date that is today, otherwise NO. Today will be treated as whatever is returned
 by [NSDate date].
 */
- (BOOL)isToday;

/**
 Returns the positive number of minutes ago that this NSDate represents. If this NSDate is in the future, then
 the result will be negative.
 */
- (NSInteger)minutesAgo;

/**
 Takes an input string and returns a date
 @param input String to parse
 @param formatter Formatter to use
 */
+ (NSDate *)dateFromString:(NSString *)input
             withFormatter:(NSDateFormatter *)formatter;

@end

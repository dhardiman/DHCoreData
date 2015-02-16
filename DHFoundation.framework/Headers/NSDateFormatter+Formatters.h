//
//  NSDateFormatter+Formatters.h
//  DHFoundation
//
//  Created by David Hardiman on 17/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 Useful custom date formatters
 */
@interface NSDateFormatter (Formatters)

/**
 Creates a date formatter with the specified format and adds to cache
 for use in future.
 Locale is set to en_US_POSIX by default. Manually change if required.
 @param format The date format to use
 */
+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format;

/**
 Creates a date formatter with the specified format
 Locale is set to en_US_POSIX by default. Manually change if required
 @param format The date format to use
 @param shouldCache Should we cache the formatter for later use?
 */
+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format cache:(BOOL)shouldCache;

/**
 Creates a date formatter with the specified format
 @param format The date format to use
 @param locale The locale to use
 @param shouldCache Should we cache the formatter for later use?
 */
+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format locale:(NSLocale *)locale cache:(BOOL)shouldCache;

@end

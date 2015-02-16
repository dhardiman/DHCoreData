/*
 File: Reachability.h
 Abstract: Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 Version: 3.5
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

/**
 *  Representation of current reachability status
 */
typedef NS_ENUM(NSUInteger, DHReachabilityStatus) {
    /**
     *  Not reachable
     */
    DHReachabilityStatusNotReachable = 0,
    /**
     *  Reachable via WIFI
     */
    DHReachabilityStatusWiFi,
    /**
     *  Reachable via WWAN
     */
    DHReachabilityStatusWWAN
};

extern NSString *const DHReachabilityChangedNotification;

/**
 *  Object for determining current reachability
 */
@interface DHReachability : NSObject

/**
 *  Reachability object to check the reachability of a particular host name.
 *
 *  @param hostName Host name to check
 *
 *  @return Configured `DHReachability` object
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/**
 *  Reachability object to check the reachability of a particular IP address.
 *
 *  @param hostAddress Host address to check
 *
 *  @return Configured `DHReachability` object
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

/**
 *  Reachability object to check whether the default route is available.
 *  Should be used to, at minimum, establish network connectivity.
 *
 *  @return Configured `DHReachability` object
 */
+ (instancetype)reachabilityForInternetConnection;

/**
 *  Reachability object to check whether a local wifi connection is available.
 *
 *  @return Configured `DHReachability` object
 */
+ (instancetype)reachabilityForLocalWiFi;

/**
 *  Start listening for reachability notifications on the current run loop.
 *
 *  @return YES if listenting was successful
 */
- (BOOL)startNotifier;

/**
 *  Stop listening for reachability notifications
 */
- (void)stopNotifier;

/**
 *  Current reachability status
 *
 *  @return The current established status
 */
- (DHReachabilityStatus)currentReachabilityStatus;

/**
 *  WWAN may be available, but not active until a connection has been established.
 *  WiFi may require a connection for VPN on Demand.
 *
 *  @return YES if a connection is required
 */
- (BOOL)connectionRequired;

/**
 Check to see if we're offline
 */
+ (BOOL)offline;

@end

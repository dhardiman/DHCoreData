//
//  testingframeworks.h
//  testingframeworks
//
//  Created by David Hardiman on 13/02/2013.
//  Copyright (c) 2013 Mobile IQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __OBJC__
#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#import "NSObject+Expecta.h" // Useful for creating custom expecta matchers
#import "OCMock.h"
#import "OCMockObject+AsyncVerify.h"
#import "OHHTTPStubs.h"
#import "OHHTTPStubsResponse+JSON.h"
#import "MIQCoreDataTestCase.h"

#define TEST_CASE_WITH_SUBCLASS(name, subclass) \
@interface name : subclass \
@end \
@implementation name \

#define TEST_CASE(name) TEST_CASE_WITH_SUBCLASS(name, XCTestCase)

#define END_TEST_CASE \
@end

#define Test(x) - (void)test##x
#endif

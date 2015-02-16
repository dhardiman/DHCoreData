//
//  OCMockObject+AsyncVerify.h
//  testingframeworks
//
//  Created by Sebastian Skuse on 25/07/2014.
//  Copyright (c) 2014 Mobile IQ Ltd. All rights reserved.
//

#import "OCMock.h"

@interface OCMockObject (AsyncVerify)

- (void)waitForVerificationWithTimeout:(NSTimeInterval)timeout;

- (void)waitForVerificationWithTimeout:(NSTimeInterval)timeout interval:(NSTimeInterval)interval;

@end

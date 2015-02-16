//
//  UIViewController+DHPrepareSegue.h
//
//  Created by David Hardiman on 01/04/2014.
//  Copyright (c) 2014 David Hardiman. All rights reserved.
//
#import <UIKit/UIKit.h>

/**
 Wrapper around objc_msgSend to allow us to do a similar
 thing to performSelector: whilst avoid ARC warnings
 */
@interface UIViewController (DHPrepareSegue)

/**
 Takes a segue identifier and runs perform selector against it. If the identifier has no colons, no
 arguments are passed, if one, the destination view controller is passed, if two, then the destination
 and source view controller are passed. It is also possible to pass the sender if part of the selector
 name is called sender:

 @param segueIdentifier      The identifier of the segue
 @param destination          Destination view controller for the segue
 @param source               Source view controller for the segue
 @param sender               Sender object. Requires one part of the selector name to be called sender:
 */
- (void)dh_prepareSegueWithIdentifier:(NSString *)segueIdentifier
            destinationViewController:(UIViewController *)destination
                 sourceViewController:(UIViewController *)source
                               sender:(id)sender;

@end

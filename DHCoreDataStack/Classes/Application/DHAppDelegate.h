//
//  DHAppDelegate.h
//  DHCoreDataStack
//
//  Created by David Hardiman on 09/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHViewController;

@interface DHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DHViewController *viewController;

@end

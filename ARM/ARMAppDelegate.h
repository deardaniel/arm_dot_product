//
//  ARMAppDelegate.h
//  ARM
//
//  Created by Daniel Heffernan on 30/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARMViewController;

@interface ARMAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ARMViewController *viewController;

@end

//
//  ARMAppDelegate.m
//  ARM
//
//  Created by Daniel Heffernan on 30/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ARMAppDelegate.h"

#import "ARMViewController.h"
#import "Accelerate/Accelerate.h"

@implementation ARMAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

int test(int32_t *,int32_t *, int32_t);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    int32_t x[] = { 10, 20, 30, 40 };
    int32_t y[] = { 10, 9, 8, 7 };
    
    int32_t res = test(x, y, 4);
    NSLog(@"Result: %d", res);

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end

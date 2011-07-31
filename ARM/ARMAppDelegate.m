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

void test_int32(int32_t *,int32_t *, int32_t);
int32_t dot_product_int32(int32_t *,int32_t *, int32_t);
int32_t dot_product_int32_asm(int32_t *,int32_t *, int32_t);

void test_int32(int32_t *x,int32_t *y, int32_t n) {
    int32_t cResult = dot_product_int32(x, y, n);
    int32_t asmResult = dot_product_int32_asm(x, y, n);
    printf("%d => %d :: %d (%s)\n",
           n,
           cResult,
           asmResult,
           cResult == asmResult ? "SUCCESS" : "FAIL");
}

int32_t dot_product_int32(int32_t *x,int32_t *y, int32_t n) {
    int32_t sum = 0;
    while (--n >= 0) sum += x[n] * y[n];
    return sum;
}

#ifdef __ARM_NEON__
void test_float(float *,float *, int32_t);
float dot_product_float(float *,float *, int32_t);
float dot_product_float_asm(float *,float *, int32_t);

void test_float(float *x,float *y, int32_t n) {
    float cResult = dot_product_float(x, y, n);
    float asmResult = dot_product_float_asm(x, y, n);
    printf("%d => %f :: %f (%s)\n",
           n,
           cResult,
           asmResult,
           cResult == asmResult ? "SUCCESS" : "FAIL");
}

float dot_product_float(float *x,float *y, int32_t n) {
    float sum = 0.0f;
    while (--n >= 0) sum += x[n] * y[n];
    return sum;
}
#endif


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    {
        int32_t x[] = { 10, 20, 30, 40,
                        50, 60, 70, 80,
                        90, 100 };
        int32_t y[] = { 10, 9, 8, 7,
                        6, 5, 4, 3,
                        2, 1 };
        
        for (int i=0; i<=10; i++)
            test_int32(x, y, i);
    }
#ifdef __ARM_NEON__
    {
        float x[] = { 10.0f, 20.0f, 30.0f, 40.0f,
                        50.0f, 60.0f, 70.0f, 80.0f,
                        90.0f, 100.0f };
        float y[] = { 10.0f, 9.0f, 8.0f, 7.0f,
                        6.0f, 5.0f, 4.0f, 3.0f,
                        2.0f, 1.0f };
        
        for (int i=0; i<=10; i++)
            test_float(x, y, i);
        
    }
#endif
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

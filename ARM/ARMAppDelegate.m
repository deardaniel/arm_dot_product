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

#define MAX_VECTOR_LENGTH 10
#define MAX_TEST_VALUE 100
#define MAX_ABS_ERROR 1.0e-6

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
    float error = fabs(asmResult - cResult) / cResult;
    printf("%d => %f :: %f (%f => %s)\n",
           n,
           cResult,
           asmResult,
           error,
           error < MAX_ABS_ERROR ? "SUCCESS" : "FAIL");
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
        int32_t *x = malloc(sizeof(int32_t) * MAX_VECTOR_LENGTH);
        int32_t *y = malloc(sizeof(int32_t) * MAX_VECTOR_LENGTH);
        
        for (int i=0; i<MAX_VECTOR_LENGTH; i++) {
            x[i] = rand() % MAX_TEST_VALUE;
            y[i] = rand() % MAX_TEST_VALUE;
        }
        
        for (int i=0; i<=MAX_VECTOR_LENGTH; i++)
            test_int32(x, y, i);
    }
#ifdef __ARM_NEON__
    {
        float *x = malloc(sizeof(float) * MAX_VECTOR_LENGTH);
        float *y = malloc(sizeof(float) * MAX_VECTOR_LENGTH);
        
        for (int i=0; i<MAX_VECTOR_LENGTH; i++) {
            x[i] = ((float)rand()/RAND_MAX) * MAX_TEST_VALUE;
            y[i] = ((float)rand()/RAND_MAX) * MAX_TEST_VALUE;
        }
        
        printf("\n == Float Test ==\n x = ( ");
        for (int i=0; i<MAX_VECTOR_LENGTH; i++)
            printf("%f ", x[i]);
        printf(")\n y = ( ");
        for (int i=0; i<MAX_VECTOR_LENGTH; i++)
            printf("%f ", y[i]);
        printf(")\n\n");
        
        for (int i=0; i<=MAX_VECTOR_LENGTH; i++)
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

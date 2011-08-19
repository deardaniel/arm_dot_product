//
//  main.m
//  ARM
//
//  Created by Daniel Heffernan on 30/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#include <mach/mach_time.h>

#define MAX_TEST_VALUE 100
#define TEST_VALUES 10, 100, 500, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 128000, 256000, 512000
#define MAX_ABS_ERROR 1.0e-5
#define TEST_ITERATIONS

void test_int32(int32_t *,int32_t *, int32_t);
int32_t dot_product_int32(int32_t *,int32_t *, int32_t);
int32_t dot_product_int32_accelerate(int32_t *,int32_t *, int32_t);
int32_t dot_product_int32_asm(int32_t *,int32_t *, int32_t);

void test_int32(int32_t *x,int32_t *y, int32_t n) {
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    uint64_t cStart = mach_absolute_time();
    int32_t cResult = dot_product_int32(x, y, n);
    uint64_t cTime = mach_absolute_time() - cStart;
    cTime = cTime * info.numer / info.denom;

    uint64_t asmStart = mach_absolute_time();
    int32_t asmResult = dot_product_int32_asm(x, y, n);
    uint64_t asmTime = mach_absolute_time() - asmStart;
    asmTime = asmTime * info.numer / info.denom;

    printf("%d,%d,%d,%llu,%llu\n",
           n,
           cResult,
           asmResult,
//           cResult == asmResult ? "SUCCESS" : "FAIL",
           cTime,
           asmTime);
}

int32_t dot_product_int32(int32_t *x,int32_t *y, int32_t n) {
    int32_t sum = 0;
    while (--n >= 0) sum += x[n] * y[n];
    return sum;
}

int32_t dot_product_int32_accelerate(int32_t *x,int32_t *y, int32_t n) {
    float *xf = malloc(sizeof(float) * n);
    float *yf = malloc(sizeof(float) * n);
    vDSP_vflt32(x, 1, xf, 1, n);
    vDSP_vflt32(y, 1, yf, 1, n);
    
    float result;
    vDSP_dotpr(xf, 1, yf, 1, &result, n);
    return (int32_t)result;
}

#ifdef __ARM_NEON__
void test_float(float *,float *, int32_t);
float dot_product_float(float *,float *, int32_t);
float dot_product_float_accelerate(float *,float *, int32_t);
float dot_product_float_asm(float *,float *, int32_t);

void test_float(float *x,float *y, int32_t n) {
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    uint64_t cStart = mach_absolute_time();
    float cResult = dot_product_float(x, y, n);
    uint64_t cTime = mach_absolute_time() - cStart;
    cTime = cTime * info.numer / info.denom;
    
    uint64_t accelerateStart = mach_absolute_time();
    float accelerateResult = dot_product_float_accelerate(x, y, n);
    uint64_t accelerateTime = mach_absolute_time() - accelerateStart;
    accelerateTime = accelerateTime * info.numer / info.denom;

    uint64_t asmStart = mach_absolute_time();
    float asmResult = dot_product_float_asm(x, y, n);
    uint64_t asmTime = mach_absolute_time() - asmStart;
    asmTime = asmTime * info.numer / info.denom;

//    float error = fabs(asmResult - (cResult + accelerateResult) / 2.0f) / cResult;
    printf("%d,%f,%f,%f,%llu,%llu,%llu\n",
           n,
           cResult,
           accelerateResult,
           asmResult,
//           error < MAX_ABS_ERROR ? "OK" : "HIGH-ERROR", 
           cTime,
           accelerateTime,
           asmTime);
}

float dot_product_float(float *x,float *y, int32_t n) {
    float sum = 0.0f;
    while (--n >= 0) sum += x[n] * y[n];
    return sum;
}

float dot_product_float_accelerate(float *x,float *y, int32_t n) {
    float result;
    vDSP_dotpr(x, 1, y, 1, &result, n);
    return result;
}
#endif


int main(int argc, char *argv[])
{
    const int test_values[] = { TEST_VALUES };
    const int test_value_count = sizeof(test_values) / sizeof(*test_values);
    int max_vector_length = 0;
    for (int i=0; i < test_value_count; i++)
        max_vector_length = MAX(max_vector_length, test_values[i]);
    {
        int32_t *x = malloc(sizeof(int32_t) * max_vector_length);
        int32_t *y = malloc(sizeof(int32_t) * max_vector_length);
        
        for (int i=0; i<max_vector_length; i++) {
            x[i] = rand() % MAX_TEST_VALUE;
            y[i] = rand() % MAX_TEST_VALUE;
        }
        
        printf("n,C Result,ASM Result,C Time,ASM Time\n");
        
        for (int i=0; i < test_value_count; i++)
            test_int32(x, y, test_values[i]);
    }
#ifdef __ARM_NEON__
    {
        float *x = malloc(sizeof(float) * max_vector_length);
        float *y = malloc(sizeof(float) * max_vector_length);
        
        for (int i=0; i<max_vector_length; i++) {
            x[i] = ((float)rand()/RAND_MAX) * MAX_TEST_VALUE;
            y[i] = ((float)rand()/RAND_MAX) * MAX_TEST_VALUE;
        }
        
        printf("n,C Result,vDSP Result,ASM Result,C Time,vDSP Time,ASM Time\n");
//        printf("x = ( ");
//        for (int i=0; i<max_vector_length; i++)
//            printf("%f ", x[i]);
//        printf(")\n y = ( ");
//        for (int i=0; i<max_vector_length; i++)
//            printf("%f ", y[i]);
//        printf(")\n\n");
        
        for (int i=0; i < test_value_count; i++)
            test_float(x, y, test_values[i]);
        
    }
#endif
    fflush(stdout);
    return 0;
}

//
//  Test.s
//  ARM
//
//  Created by Daniel Heffernan on 30/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#def pushd vstmdb sp!, 
//#def popd vldmia sp!, 


.text
.align 4
.globl _test

_test:

#ifdef __arm__
#ifdef __ARM_NEON__

    vstmdb sp!, {d0-d5}
    vmov.s32 q0,#0

    //VLD1.S16          {Q0, Q1}, [r0]!
    vld1.s32 {q1},[r0]!
    vld1.s32 {q2},[r1]!

    vmul.s32 q1, q1, q2

    vpadd.s32 d0, d2, d3
    vpadd.s32 d0, d0, d0
    vmov.s32 r0, s0

    vldmia sp!, {d0-d5}

#else 


    push {r4-r7}

        mov r6,#0

        .Lloop:
            ldr r4,[r0],#4
            ldr r5,[r1],#4

            mul r4,r4,r5
            add r6,r6,r4

            subs r2,r2,#1
            bne .Lloop

        mov r0, r6

    pop {r4-r7}




#endif

    mov pc,lr

#endif





//#ifdef __arm__
//#ifdef __ARM_NEON__
//vmov.s32 q0,#0
//
////VLD1.S16          {Q0, Q1}, [r0]!
//vld1.s32 {q4},[r0]!
//vld1.s32 {q5},[r1]!
//
//vmul.s32 q4, q4, q5
//
//vpadd.s32 d0, d8, d9
//vpadd.s32 d0, d0, d0
//vmov.s32 r0, s0
//
//#endif
//#endif


//
//
//
//#ifdef __i386__
//
//.globl _test
//_test:
//    movl $255,%eax
//    ret
//
//#endif

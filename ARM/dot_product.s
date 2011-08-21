//
//  dot_product.s
//
//  Created by Daniel Heffernan on 30/07/2011.
//

#ifdef __arm__

.text
.align 4
.globl _dot_product_int32_asm

_dot_product_int32_asm: // function for calculating dot product of int32 arrays
                        // int32_t dot_product_int32_asm(int32_t *,int32_t *, int32_t);

    push {r4-r6,lr}     // push preserved registers onto stack
    mov r6, #0          // set our accumulator to 0

    cmp r2, #0          // compare vector size to 0
    beq .Lend           // if equal, exit

#ifdef __ARM_NEON__

    cmp r2, #8          // compare vector size to 8
    blt .Lsingleloop    // if less than, skip NEON code

    vmov.s32 q0, #0     // set NEON accumulator to 0
                        // We use d0 to accumulate 2 words which
                        // will be added together before returning.

    .Lbatchloop:        // loop for processing 8 elements at a time

        vld1.s32 {q1-q2},[r0]!  // load (pre-increment) 8 elements from *r0 (x)
        vld1.s32 {q3-q4},[r1]!  // load (pre-increment) 8 elements from *r1 (y)

        vmul.s32 q1, q1, q3     // multiply the 1st 4 elements of x by the 1st 4 of y
        vmul.s32 q3, q2, q4     // multiply the 2nd 4 elements of x by the 2nd 4 of y

        vpadd.s32 d1, d2, d3    // add results of 1st multiply
        vpadd.s32 d6, d7, d6    // add results of 2nd multiply
        vpadd.s32 d1, d1, d6    // add results of additions

        vpadd.s32 d0, d0, d1    // add to accumulator
        subs r2, r2, #8         // remove 8 from vector size
        cmp r2, #8              // compare vector size to 8
        bge .Lbatchloop         // repeat NEON code if 8 or more exist

    vpadd.s32 d0, d0, d0    // add the 2 numbers in the accumulator
    vmov.s32 r6, s0         // move to r6 from NEON memory

    cmp r2, #0          // compare vector size to 0
    beq .Lend           // if equal, exit

#endif

    .Lsingleloop:       // loop for processing 1 element at a time
        ldr r4,[r0],#4  // load (post-increment) 1 element from x
        ldr r5,[r1],#4  // load (post-increment) 1 element from y

        mul r4,r4,r5    // multiply the values together
        add r6,r6,r4    // add the result to the accumulator

        subs r2,r2,#1   // remove 1 from the vector size and update condition flags
        bne .Lsingleloop// repeat loop if we haven't reached 0


    .Lend:              // finally...
        mov r0, r6      // move accumulator value to r0 for return
        pop {r4-r6,lr}  // pop the values from the stack
        mov pc,lr       // return


#ifdef __ARM_NEON__

.globl _dot_product_float_asm   
_dot_product_float_asm: // function for calculating dot product of float arrays
                        // float dot_product_float_asm(float *,float *, int32_t);
    // note no push required because:
    //  - No preserved registers used.
    //  - No subroutines called (LR doesn't change).

    vmov.f32 q0, #0.0       // set accumulator to 0

    cmp r2, #0              // compare vector size to 0
    beq .Lfend              // if equal, exit

    cmp r2, #8              // compare vector size to 8
    blt .Lfsingleloop       // if less than, skip batch (8-element) code

    .Lfbatchloop:           // loop for processing 8 elements at a time
        vld1.f32 {q1-q2},[r0]!  // load (pre-increment) 8 elements from *r0 (x)
        vld1.f32 {q3-q4},[r1]!  // load (pre-increment) 8 elements from *r1 (y)

        vmul.f32 q1, q1, q3     // multiply the 1st 4 elements of x by the 1st 4 of y
        vmul.f32 q3, q2, q4     // multiply the 2nd 4 elements of x by the 2nd 4 of y

        vpadd.f32 d1, d2, d3    // add results of 1st multiply    
        vpadd.f32 d6, d7, d6    // add results of 2nd multiply
        vpadd.f32 d1, d1, d6    // add results of additions

        vpadd.f32 d0, d0, d1    // add to accumulator
        subs r2, r2, #8         // remove 8 from vector size
        cmp r2, #8              // compare vector size to 8
        bge .Lfbatchloop        // repeat batch code if 8 or more exist

    vpadd.f32 d0, d0, d0        // add the 2 numbers in the accumulator

    cmp r2, #0              // compare vector size to 0
    beq .Lfend              // if equal, exit

    .Lfsingleloop:          // loop for processing 1 element at a time
        vldm r0!, {s1}      // load (pre-increment) 1 element from x
        vldm r1!, {s2}      // load (pre-increment) 1 element from y

        vmul.f32 s1,s1,s2   // multiply the values together
        vadd.f32 s0,s0,s1   // add the result to the accumulator

        subs r2,r2,#1       // remove 1 from the vector size and update condition flags
        bne .Lfsingleloop   // repeat loop if we haven't reached 0

    .Lfend:                 // finally...
        vmov r0, s0         // move accumulator value to r0 for return

        mov pc,lr           // return
#endif

#endif

#ifdef __i386__

.globl _dot_product_int32_asm
_dot_product_int32_asm:     // dummy to allow compilation under i386
    movl $255,%eax          // return 0xFF
    ret

#endif

//
//  dot_product.s
//
//  Created by Daniel Heffernan on 30/07/2011.
//

#ifdef __arm__

.text
.align 4
.globl _dot_product_int32_asm

_dot_product_int32_asm:
    push {r4-r6,lr}
    mov r6,#0

    cmp r2, #0
    beq .Lend

#ifdef __ARM_NEON__

    cmp r2, #8
    blt .Lsingleloop

    vmov.s32 q0,#0

    .Lbatchloop:

        vld1.s32 {q1-q2},[r0]!
        vld1.s32 {q3-q4},[r1]!

        vmul.s32 q1, q1, q3
        vmul.s32 q3, q2, q4

        vpadd.s32 d1, d2, d3
        vpadd.s32 d6, d7, d6
        vpadd.s32 d1, d1, d6

        vpadd.s32 d0, d0, d1
        subs r2, r2, #8
        cmp r2, #8
        bge .Lbatchloop

    vpadd.s32 d0, d0, d0
    vmov.s32 r6, s0

    cmp r2, #0
    beq .Lend

#endif

    .Lsingleloop:
        ldr r4,[r0],#4
        ldr r5,[r1],#4

        mul r4,r4,r5
        add r6,r6,r4

        subs r2,r2,#1
        bne .Lsingleloop


    .Lend:
        mov r0, r6
        pop {r4-r6,lr}
        mov pc,lr


#ifdef __ARM_NEON__
.globl _dot_product_float_asm
_dot_product_float_asm:
    vmov.f32 q0,#0.0

    cmp r2, #0
    beq .Lfend

    cmp r2, #8
    blt .Lfsingleloop

    .Lfbatchloop:
        vld1.f32 {q1-q2},[r0]!
        vld1.f32 {q3-q4},[r1]!

        vmul.f32 q1, q1, q3
        vmul.f32 q3, q2, q4

        vpadd.f32 d1, d2, d3
        vpadd.f32 d6, d7, d6
        vpadd.f32 d1, d1, d6

        vpadd.f32 d0, d0, d1
        subs r2, r2, #8
        cmp r2, #8
        bge .Lfbatchloop

    vpadd.f32 d0, d0, d0

    cmp r2, #0
    beq .Lfend

    .Lfsingleloop:
        vldm r0!, {s1}
        vldm r1!, {s2}

        vmul.f32 s1,s1,s2
        vadd.f32 s0,s0,s1

        subs r2,r2,#1
        bne .Lfsingleloop

    .Lfend:
        vmov r0, s0

        mov pc,lr
#endif

#endif

#ifdef __i386__

.globl _dot_product_int32_asm
_dot_product_int32_asm:
    movl $255,%eax
    ret

#endif
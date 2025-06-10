/*
 * Copyright (c) 2022 Sung Ho Park and CSOS
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <ubinos_config.h>

    .syntax unified
    .arch   armv7-m

    .text
    .thumb

    .thumb_func
    .align  1
    .globl  memset_fast
    .type   memset_fast, %function
memset_fast:
    // memset_fast.h 에서 정의된 함수, memset_fast 를 구현하라.
    // 각 매개변수 전달을 위해 사용되는 레지스터
    //    void * buffer : r0
    //    int value     : r1
    //    size_t size   : r2

    cbz     r2, end             @ size == 0 이면 종료
    mov     r3, r0              @ r3 = buffer (주소 작업용)
    ands    r1, r1, #0xFF       @ value 하위 8비트만 추출
    orr     r4, r1, r1, lsl #8
    orr     r4, r4, r4, lsl #16 @ r4 = 4바이트 모두 동일한 값

align_loop:
    tst     r3, #3              @ 4바이트 정렬 검사
    beq     word_loop
    strb    r1, [r3], #1        @ 1바이트 쓰기
    subs    r2, r2, #1
    beq     end
    b       align_loop

word_loop:
    cmp     r2, #4
    blt     byte_loop
    str     r4, [r3], #4        @ 4바이트 쓰기
    subs    r2, r2, #4
    b       word_loop

byte_loop:
    cmp     r2, #0
    beq     end
    strb    r1, [r3], #1
    subs    r2, r2, #1
    b       byte_loop

end:
    bx      lr

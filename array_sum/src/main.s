.section .data
.align 4
array:      .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
array_size: .word 10

.bss
array_sum: .skip 4

.text
.global main
main:
    /* Prologue: Reserve 56 Bytes */
    addi sp, sp, -56
    sw fp, 52(sp)
    sw ra, 48(sp)
    addi fp, sp, 56
    
    /* Save Local ArraySsize */
    li t0, 10
    sw t0, -52(fp)

    /* Fill Local Array */
    addi a0, fp, -48
    lw a1, -52(fp)
    jal ra, fillArray

    /* Local Array */
    addi a0, fp, -48
    lw a1, -52(fp)
    jal ra, sumArray
    sw a0, -56(fp)

    /* Global Array */
    la a0, array
    lw a1, array_size
    jal ra, sumArray
    la t0, array_sum
    sw a0, 0(t0)

    /* Epilogue */
    addi sp, fp, 0
    lw fp, -4(sp)
    lw ra, -8(sp)
    ret

/* int sumArray(const int *array, int array_size) */
.global sumArray
sumArray:
    addi sp, sp, -8
    sw fp, 4(sp)
    sw ra, 0(sp)
    addi fp, sp, 8

    addi t0, a0, 0 /* t0 = array */
    addi t1, a1, 0 /* t1 = array_size */
    li a0, 0       /* a0 = array_sum */

    sumArray_loop:
        beq t1, zero, sumArray_end
        addi t1, t1, -1
        lw t2, 0(t0)
        addi t0, t0, 4
        add a0, a0, t2
        j sumArray_loop

    sumArray_end:
    addi sp, fp, 0
    lw fp, -4(sp)
    lw ra, -8(sp)
    ret

/* void fillArray(int *array, int array_size) */
.global fillArray
fillArray:
    addi sp, sp, -8
    sw fp, 4(sp)
    sw ra, 0(sp)
    addi fp, sp, 8

    addi t0, a0, 0 /* t0 = array */
    li t1, 0

    fillArray_loop:
        beq t1, a1, fillArray_end
        addi t1, t1, 1
        sw t1, 0(t0)
        addi t0, t0, 4
        j fillArray_loop

    fillArray_end:
    addi sp, fp, 0
    lw fp, -4(sp)
    lw ra, -8(sp)
    ret

/* If sp = 0x1000... */ 
/* 4 for fp (at 0x0FFC) */
/* 4 for ra (at 0x0FF8) */
/* 40 for array (from 0x0FF4 (0) to 0x0FD0 (9)) */
/* 4 for array_size (at 0x0FCC) */
/* 4 for array_sum (at 0x0FC8) */
/* fp = 0x1000 & sp = 0x0FC8 */

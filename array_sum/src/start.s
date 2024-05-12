.text
.global _start
_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    la sp, __stack_pointer$
    .option pop

    jal ra, main

    li a7, 93
    li a0, 0
    ecall

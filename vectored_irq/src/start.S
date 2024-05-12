.section .init

.global _start
_start:
.option push
.option norelax
    la gp, _gp
    la sp, _sp
.option pop

data_load:
    la t0, _lmadata
    la t1, _databegin
    la t2, _dataend 
    beq t0, t1, data_end
    ble t2, t1, data_end
data_loop:
    lw a0, 0(t0)
    addi t0, t0, 4
    sw a0, 0(t1)
    addi t1, t1, 4
    bltu t1, t2, data_loop
data_end:
        
bss_clear:
    la t0, _bssbegin
    la t1, _bssend
    ble t1, t0, bss_end
bss_loop:
    sw x0, 0(t0)
    addi t0, t0, 4
    bltu t0, t1, bss_loop
bss_end:

    call main

gotlost:
    j gotlost    

.section .vector

.align 8
.global INT_VectorEntry
INT_VectorEntry:
j reserved
.align 2
j reserved
.align 2
j reserved
.align 2
j machine_software_entry
.align 2
j reserved
.align 2
j reserved
.align 2
j reserved
.align 2
j machine_timer_entry
.align 2
j reserved
.align 2
j reserved
.align 2
j reserved
.align 2
j machine_external_entry

.align 8
.global machine_software_entry
machine_software_entry:
	addi sp, sp, -31 * 4
	sw x1, 1 * 4( sp )
	sw x2, 2 * 4( sp )
	sw x3, 3 * 4( sp )
	sw x4, 4 * 4( sp )
	sw x5, 5 * 4( sp )
	sw x6, 6 * 4( sp )
	sw x7, 7 * 4( sp )
	sw x8, 8 * 4( sp )
	sw x9, 9 * 4( sp )
	sw x10, 10 * 4( sp )
	sw x11, 11 * 4( sp )
	sw x12, 12 * 4( sp )
	sw x13, 13 * 4( sp )
	sw x14, 14 * 4( sp )
	sw x15, 15 * 4( sp )
	sw x16, 16 * 4( sp )
	sw x17, 17 * 4( sp )
	sw x18, 18 * 4( sp )
	sw x19, 19 * 4( sp )
	sw x20, 20 * 4( sp )
	sw x21, 21 * 4( sp )
	sw x22, 22 * 4( sp )
	sw x23, 23 * 4( sp )
	sw x24, 24 * 4( sp )
	sw x25, 25 * 4( sp )
	sw x26, 26 * 4( sp )
	sw x27, 27 * 4( sp )
	sw x28, 28 * 4( sp )
	sw x29, 29 * 4( sp )
	sw x30, 30 * 4( sp )
	sw x31, 31 * 4( sp )

    call INT_MachineSoftwareHandler

	lw x1, 1 * 4( sp )
	lw x2, 2 * 4( sp )
	lw x3, 3 * 4( sp )
	lw x4, 4 * 4( sp )
	lw x5, 5 * 4( sp )
	lw x6, 6 * 4( sp )
	lw x7, 7 * 4( sp )
	lw x8, 8 * 4( sp )
	lw x9, 9 * 4( sp )
	lw x10, 10 * 4( sp )
	lw x11, 11 * 4( sp )
	lw x12, 12 * 4( sp )
	lw x13, 13 * 4( sp )
	lw x14, 14 * 4( sp )
	lw x15, 15 * 4( sp )
	lw x16, 16 * 4( sp )
	lw x17, 17 * 4( sp )
	lw x18, 18 * 4( sp )
	lw x19, 19 * 4( sp )
	lw x20, 20 * 4( sp )
	lw x21, 21 * 4( sp )
	lw x22, 22 * 4( sp )
	lw x23, 23 * 4( sp )
	lw x24, 24 * 4( sp )
	lw x25, 25 * 4( sp )
	lw x26, 26 * 4( sp )
	lw x27, 27 * 4( sp )
	lw x28, 28 * 4( sp )
	lw x29, 29 * 4( sp )
	lw x30, 30 * 4( sp )
	lw x31, 31 * 4( sp )

	addi sp, sp, 31 * 4

	mret

.align 8
.global machine_timer_entry
machine_timer_entry:
	addi sp, sp, -31 * 4
	sw x1, 1 * 4( sp )
	sw x2, 2 * 4( sp )
	sw x3, 3 * 4( sp )
	sw x4, 4 * 4( sp )
	sw x5, 5 * 4( sp )
	sw x6, 6 * 4( sp )
	sw x7, 7 * 4( sp )
	sw x8, 8 * 4( sp )
	sw x9, 9 * 4( sp )
	sw x10, 10 * 4( sp )
	sw x11, 11 * 4( sp )
	sw x12, 12 * 4( sp )
	sw x13, 13 * 4( sp )
	sw x14, 14 * 4( sp )
	sw x15, 15 * 4( sp )
	sw x16, 16 * 4( sp )
	sw x17, 17 * 4( sp )
	sw x18, 18 * 4( sp )
	sw x19, 19 * 4( sp )
	sw x20, 20 * 4( sp )
	sw x21, 21 * 4( sp )
	sw x22, 22 * 4( sp )
	sw x23, 23 * 4( sp )
	sw x24, 24 * 4( sp )
	sw x25, 25 * 4( sp )
	sw x26, 26 * 4( sp )
	sw x27, 27 * 4( sp )
	sw x28, 28 * 4( sp )
	sw x29, 29 * 4( sp )
	sw x30, 30 * 4( sp )
	sw x31, 31 * 4( sp )

    call INT_MachineTimerHandler

	lw x1, 1 * 4( sp )
	lw x2, 2 * 4( sp )
	lw x3, 3 * 4( sp )
	lw x4, 4 * 4( sp )
	lw x5, 5 * 4( sp )
	lw x6, 6 * 4( sp )
	lw x7, 7 * 4( sp )
	lw x8, 8 * 4( sp )
	lw x9, 9 * 4( sp )
	lw x10, 10 * 4( sp )
	lw x11, 11 * 4( sp )
	lw x12, 12 * 4( sp )
	lw x13, 13 * 4( sp )
	lw x14, 14 * 4( sp )
	lw x15, 15 * 4( sp )
	lw x16, 16 * 4( sp )
	lw x17, 17 * 4( sp )
	lw x18, 18 * 4( sp )
	lw x19, 19 * 4( sp )
	lw x20, 20 * 4( sp )
	lw x21, 21 * 4( sp )
	lw x22, 22 * 4( sp )
	lw x23, 23 * 4( sp )
	lw x24, 24 * 4( sp )
	lw x25, 25 * 4( sp )
	lw x26, 26 * 4( sp )
	lw x27, 27 * 4( sp )
	lw x28, 28 * 4( sp )
	lw x29, 29 * 4( sp )
	lw x30, 30 * 4( sp )
	lw x31, 31 * 4( sp )

	addi sp, sp, 31 * 4

	mret

.align 8
.global machine_external_entry
machine_external_entry:
	addi sp, sp, -31 * 4
	sw x1, 1 * 4( sp )
	sw x2, 2 * 4( sp )
	sw x3, 3 * 4( sp )
	sw x4, 4 * 4( sp )
	sw x5, 5 * 4( sp )
	sw x6, 6 * 4( sp )
	sw x7, 7 * 4( sp )
	sw x8, 8 * 4( sp )
	sw x9, 9 * 4( sp )
	sw x10, 10 * 4( sp )
	sw x11, 11 * 4( sp )
	sw x12, 12 * 4( sp )
	sw x13, 13 * 4( sp )
	sw x14, 14 * 4( sp )
	sw x15, 15 * 4( sp )
	sw x16, 16 * 4( sp )
	sw x17, 17 * 4( sp )
	sw x18, 18 * 4( sp )
	sw x19, 19 * 4( sp )
	sw x20, 20 * 4( sp )
	sw x21, 21 * 4( sp )
	sw x22, 22 * 4( sp )
	sw x23, 23 * 4( sp )
	sw x24, 24 * 4( sp )
	sw x25, 25 * 4( sp )
	sw x26, 26 * 4( sp )
	sw x27, 27 * 4( sp )
	sw x28, 28 * 4( sp )
	sw x29, 29 * 4( sp )
	sw x30, 30 * 4( sp )
	sw x31, 31 * 4( sp )

    call INT_MachineExternalHandler

	lw x1, 1 * 4( sp )
	lw x2, 2 * 4( sp )
	lw x3, 3 * 4( sp )
	lw x4, 4 * 4( sp )
	lw x5, 5 * 4( sp )
	lw x6, 6 * 4( sp )
	lw x7, 7 * 4( sp )
	lw x8, 8 * 4( sp )
	lw x9, 9 * 4( sp )
	lw x10, 10 * 4( sp )
	lw x11, 11 * 4( sp )
	lw x12, 12 * 4( sp )
	lw x13, 13 * 4( sp )
	lw x14, 14 * 4( sp )
	lw x15, 15 * 4( sp )
	lw x16, 16 * 4( sp )
	lw x17, 17 * 4( sp )
	lw x18, 18 * 4( sp )
	lw x19, 19 * 4( sp )
	lw x20, 20 * 4( sp )
	lw x21, 21 * 4( sp )
	lw x22, 22 * 4( sp )
	lw x23, 23 * 4( sp )
	lw x24, 24 * 4( sp )
	lw x25, 25 * 4( sp )
	lw x26, 26 * 4( sp )
	lw x27, 27 * 4( sp )
	lw x28, 28 * 4( sp )
	lw x29, 29 * 4( sp )
	lw x30, 30 * 4( sp )
	lw x31, 31 * 4( sp )

	addi sp, sp, 31 * 4

	mret

.align 8
.global reserved
reserved:
	j reserved

OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
ENTRY(_start)

MEMORY {
    rom : ORIGIN = 0x00000000, LENGTH = 1M 
    ram : ORIGIN = 0x10000000, LENGTH = 500K
    dtim : ORIGIN = 0x2000000, LENGTH = 200K
} 

SECTIONS {
    .text : ALIGN(4) {
        *(.text)
    } >rom

    .data : ALIGN(4) {
        PROVIDE( __global_pointer$ = .);
        *(.data)
    } >ram

    .stack : ALIGN(4) {
        . = ADDR(.data) + LENGTH(ram) - 4K;
        PROVIDE( __stack_pointer$ = .);
        *(.stack)
    } >ram

    .bss : ALIGN(4) {
        *(.bss)
    } >dtim
}

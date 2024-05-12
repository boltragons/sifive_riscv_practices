OUTPUT_ARCH( "riscv" )

ENTRY( _start )

MEMORY
{
  flash (rxai!w) : ORIGIN = 0x20010000, LENGTH = 512M
  ram (w!xari) : ORIGIN = 0x80000000, LENGTH = 16K
}

PHDRS
{
  flash PT_LOAD;
  ram_init PT_LOAD;
  ram PT_NULL;
}

SECTIONS
{
  _stack_size = DEFINED(_stack_size) ? _stack_size : 1K;

  .text :
  {
    *(.vector .vector.*)
    *(.init .init.*)
    *(.text .text.*)
  } >flash AT>flash : flash

  .lmadata :
  {
    . = ALIGN(4);
    PROVIDE(_lmadata = .);
  } > flash AT>flash : flash

  .data :
  {
    . = ALIGN(4);
    PROVIDE(_databegin = .);
    *(.data .data.*)
    . = ALIGN(8);
    PROVIDE( _gp = . + 0x800 );
    *(.sdata .sdata.*)
    . = ALIGN(4);
    PROVIDE(_dataend = .);
  } >ram AT>flash : ram_init

  PROVIDE(_bssbegin = .);
  .bss            :
  {
    *(.sbss*)
    *(.bss .bss.*)
    *(COMMON)
    . = ALIGN(4);
  } >ram AT>ram : ram

  . = ALIGN(8);
  PROVIDE(_bssend = .);
  PROVIDE( _end = . );
    
  . = ALIGN(16);
   .stack ORIGIN(ram) + LENGTH(ram) - _stack_size :
  {
    PROVIDE( _heap_end = . );
    . = _stack_size;
    PROVIDE( _sp = . );
  } >ram AT>ram : ram
}

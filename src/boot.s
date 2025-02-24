// Setting constants
.set ALIGN,     1<<0
.set MEMINFO,   1<<1
.set FLAGS,     ALIGN | MEMINFO
.set MAGIC,     0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

// Multiboot
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .bss
.align 16

// create stack from bottom up
stack_bottom:
.skip 16384
stack_top:

.section .text
.global start
.type start, @function

start:
    mov $stack_top, %esp
    call main

    // stop interrupts
    cli

    // infinite loop
1:  hlt
    jmp 1b


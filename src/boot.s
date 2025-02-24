.bits 32

// Setting constants
.set ALIGN,     1<<0
.set MEMINFO,   1<<1
.set FLAGS,     ALIGH | MEMINFO
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
stack top:

.section .text
.global start
.type start, @function

// Main from kernel
extern main
start:
    mov $stack_top, %esp
    call kernel_main

    // stop interrupts
    cli

    // infinite loop
1:  hlt
    jmp 1b


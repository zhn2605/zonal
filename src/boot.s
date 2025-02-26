// Setting constants
.set ALIGN,         1<<0
.set MEMINFO,       1<<1
.set FRAMEBUFFER,   1<<2
.set FLAGS,         ALIGN | MEMINFO | FRAMEBUFFER
.set MAGIC,         0x1BADB002
.set CHECKSUM,      -(MAGIC + FLAGS)

// Multiboot
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

// Framebuffer preferences
framebuffer_tag_start:
    .long 5             // type = framebuffer
    .long 20            // size
    .long framebuffer_tag_end - framebuffer_tag_start // total size
    .long 0             // perferred width (0 = any)
    .long 0             // perferred height
    .long 32            // perferred bit depth
framebuffer_tag_end:
    .long 0             // end tag type
    .long 8             // end tag size

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
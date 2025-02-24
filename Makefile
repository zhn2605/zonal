BOOT=src/boot.s
KERNEL=src/kernel.c
ISOFILE=build/zonal.iso
KERNEL_BIN=build/zonal.bin
LINKER=boot/linker.ld

CC=i686-elf-gcc
AS=i686-elf-as
LD=i686-elf-ld
OBJCOPY=i686-elf-objcopy
CFLAGS=-ffreestanding -m32 -nostdlib -lgcc
ASFLAGS=
LDFLAGS=-T $(LINKER) --oformat=elf32-i386

DEBUG_FLAGS=-g

all: build

build: clean
	mkdir -p build
	$(AS) $(ASFLAGS) $(BOOT) -o build/boot.o
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) -c $(KERNEL) -o build/kernel.o
	$(LD) $(LDFLAGS) $(DEBUG_FLAGS) -o build/kernel.elf build/boot.o build/kernel.o
	$(OBJCOPY) -O binary build/kernel.elf $(KERNEL_BIN)
	rm -rf iso
	mkdir -p iso/boot/grub
	cp $(KERNEL_BIN) iso/boot/zonal.bin
	cp boot/grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISOFILE) iso

run: build
	qemu-system-i386 -cdrom $(ISOFILE)

debug: build
	qemu-system-i386 -cdrom $(ISOFILE) -s -S

clean:
	rm -rf build iso

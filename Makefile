#
# Compiler & Tools
#
CC=i686-elf-gcc
LD=i686-elf-gcc
AS=i686-elf-as
OBJCOPY=i686-elf-objcopy

#
# Directories
#
SRCDIR=src
BUILDDIR=build
INCLUDEDIR=include
ISODIR=isodir

#
# Flags
#
CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra -I$(INCLUDEDIR)
LDFLAGS=-T boot/linker.ld -ffreestanding -O2 -nostdlib -lgcc

#
# Files
#
SOURCES=$(SRCDIR)/kernel.c $(SRCDIR)/boot.s
OBJECTS=$(BUILDDIR)/kernel.o $(BUILDDIR)/boot.o
TARGET=$(BUILDDIR)/zonal.bin
ISO_TARGET=zonal.iso

#
# Default target
#
all: $(TARGET)

#
# Compile C files
#
$(BUILDDIR)/kernel.o: $(SRCDIR)/kernel.c
	mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) -c $< -o $@

#
# Compile assembly files
#
$(BUILDDIR)/boot.o: $(SRCDIR)/boot.s
	mkdir -p $(BUILDDIR)
	$(AS) -c $< -o $@

#
# Link
#
$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

#
# Create ISO
#
$(ISO_TARGET): $(TARGET)
	mkdir -p $(ISODIR)/boot/grub
	cp $(TARGET) $(ISODIR)/boot/zonal.bin
	cp boot/grub.cfg $(ISODIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO_TARGET) $(ISODIR)
#
# Run in QEMU
#
run: $(ISO_TARGET)
	qemu-system-i386 -cdrom $(ISO_TARGET)
#
# Clean up compiled files
#
clean:
	rm -rf $(BUILDDIR) $(ISO_TARGET) $(ISODIR)/boot/zonal.bin
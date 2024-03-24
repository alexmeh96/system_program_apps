ASM=nasm

SRC_DIR=src
BUILD_DIR=build

all: floppy_image

clean:
	rm -rf $(BUILD_DIR)

run: $(BUILD_DIR)/main.img
	qemu-system-i386 -fda build/main.img


$(BUILD_DIR): 
	mkdir $(BUILD_DIR)

#
# floppy image
#
floppy_image: $(BUILD_DIR)/main.img 
$(BUILD_DIR)/main.img: bootloader kernel | $(BUILD_DIR)
	dd if=/dev/zero of=$(BUILD_DIR)/main.img bs=512 count=2880
	mkfs.fat -F 12 -n "JAZZOS" $(BUILD_DIR)/main.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main.img conv=notrunc
	mcopy -i $(BUILD_DIR)/main.img $(BUILD_DIR)/kernel.bin "::kernel.bin"


#
# bootloader
#
bootloader: $(BUILD_DIR)/bootloader.bin
$(BUILD_DIR)/bootloader.bin: | $(BUILD_DIR)
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin


#
# kernel
#
kernel: $(BUILD_DIR)/kernel.bin
$(BUILD_DIR)/kernel.bin: | $(BUILD_DIR)
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

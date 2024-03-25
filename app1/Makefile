ASM=nasm

SRC_DIR=src
BUILD_DIR=build

.PHONY: all clean run

all: $(BUILD_DIR)/main.img

clean:
	rm -rf $(BUILD_DIR)

run: $(BUILD_DIR)/main.img
	qemu-system-i386 -fda $(BUILD_DIR)/main.img

run2: $(BUILD_DIR)/main.img
	qemu-system-i386 -boot c -m 256 -hda $(BUILD_DIR)/main.img

debug: $(BUILD_DIR)/main.img
	qemu-system-i386 -boot c -m 256 -hda $(BUILD_DIR)/main.img -s -S

$(BUILD_DIR): 
	mkdir $(BUILD_DIR)

#
# floppy image
#
$(BUILD_DIR)/main.img: $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/kernel.bin | $(BUILD_DIR)
	dd if=/dev/zero of=$(BUILD_DIR)/main.img bs=512 count=2880
	mkfs.fat -F 12 -n "JAZZOS" $(BUILD_DIR)/main.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main.img conv=notrunc
	mcopy -i $(BUILD_DIR)/main.img $(BUILD_DIR)/kernel.bin "::kernel.bin"


#
# bootloader
#
$(BUILD_DIR)/bootloader.bin: $(SRC_DIR)/bootloader/boot.asm | $(BUILD_DIR)
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin


#
# kernel
#
$(BUILD_DIR)/kernel.bin: $(SRC_DIR)/kernel/main.asm | $(BUILD_DIR)
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

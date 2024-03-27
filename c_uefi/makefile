# .POSIX:
.PHONY: all run clean build test

SRC_DIR=src
BUILD_DIR=build
CC = gcc
#CC = clang
CFLAGS = -std=c17 -Wall -Wextra -Wpedantic -O2 

all: build

build: ${BUILD_DIR}/write_gpt
${BUILD_DIR}/write_gpt: ${SRC_DIR}/write_gpt.c | create_${BUILD_DIR}
	${CC} ${CFLAGS} ${SRC_DIR}/write_gpt.c -o ${BUILD_DIR}/write_gpt

run: ${BUILD_DIR}/test.img
${BUILD_DIR}/test.img: ${BUILD_DIR}/write_gpt | create_${BUILD_DIR}
	cd ${BUILD_DIR} && ./write_gpt

test: ${BUILD_DIR}/test.img
	cd ${BUILD_DIR} && sgdisk -p test.img

create_${BUILD_DIR}:
ifeq ("$(wildcard ${BUILD_DIR})","")
	mkdir ${BUILD_DIR}
endif

clean:
	rm -rf $(BUILD_DIR)
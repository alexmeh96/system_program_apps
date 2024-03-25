ORG 0x7c00
BITS 16

jmp short main
nop

bdb_oem:                    db  'MSWIN4.1'
bdb_bytes_per_sector:       dw  512
bdb_sectors_per_cluster:    db  1
bdb_reserved_sectors:       dw  1
bdb_fat_count:              db  2
bdb_dir_entries_count:      dw 0e0h
bdb_total_sectors:          dw  2880
bdb_media_descriptor_type:  db  0f0h
bdb_sectors_per_fat:        dw  9
bdb_sectors_per_track:      dw  18
bdb_heads:                  dw  2
bdb_hidden_sectors:         dd  0
bdb_large_sector_count:     dd  0

; extended boot record
ebr_drive_number:           db 0
                            db 0
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h
ebr_volume_label:           db '  JAZZ OS  '
ebr_system_id:              db 'FAT12   '

main:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    
    mov sp, 0x7c00

    mov [ebr_drive_number], dl
    mov ax, 1
    mov cl, 1
    mov bx, 0x7e00
    call disk_read

    mov si, os_boot_msg
    call print

    ;4 segments
    ;reserved segment: 1 sector
    ;FAT: 9 * 2 = 18 sectors
    ;Root derectory:
    ;Data

    mov ax, [bdb_sectors_per_fat]
    mov bl, [bdb_fat_count]
    xor bh, bh
    mul bx
    add ax, [bdb_reserved_sectors]  ;LBA of the root directory
    push ax

    mov ax, [bdb_dir_entries_count]
    shl ax, 5  ;ax *= 32
    xor dx, dx
    div word [bdb_bytes_per_sector]  ;(32*num of entries)/bytes per sector

    test dx, dx
    jz rootDirAfter
    inc ax

rootDirAfter:
    mov cl, al
    pop ax
    mov dl, [ebr_drive_number]
    mov bx, buffer
    call disk_read

    xor bx, bx
    mov di, buffer

searckKernel:
    mov si, file_kernel_bin
    mov cx, 11
    push di
    repe cmpsb
    pop di
    je foundKernel

    add di, 32
    inc bx
    cmp bx, [bdb_dir_entries_count]
    jl searckKernel

    jmp kernelNotFound

kernelNotFound:
    mov si, msg_kernel_not_found
    call print

    hlt
    jmp halt

foundKernel:
    mov ax, [di+26]
    mov [kernel_cluster], ax

    mov ax, [bdb_reserved_sectors]
    mov bx, buffer
    mov cl, [bdb_sectors_per_fat]
    mov dl, [ebr_drive_number]

    call disk_read

    mov bx, kernel_load_segment
    mov es, bx
    mov bx, kernel_load_offset

loadKernelLoop:
    mov ax, [kernel_cluster]
    add ax, 31
    mov cl, 1
    mov dl, [ebr_drive_number]

    call disk_read

    add bx, [bdb_bytes_per_sector]
    mov ax, [kernel_cluster]  ;(kernel cluster * 3)/2
    mov cx, 3
    mul cx
    mov cx, 2
    div cx

    mov si, buffer
    add si, ax
    mov ax, [ds:si]

    or dx, dx
    jz even

odd:
    shr ax, 4
    jmp nextClusterAfter
even:
    and ax, 0x0fff

nextClusterAfter:
    cmp ax, 0x0ff8
    jae readFinish

    mov [kernel_cluster], ax
    jmp loadKernelLoop

readFinish:
    mov dl, [ebr_drive_number]
    mov ax, kernel_load_segment
    mov ds, ax
    mov es, ax

    jmp kernel_load_segment:kernel_load_offset

    hlt

halt:
    jmp halt

;input: LBA index in ax
;cx [bits 0-5]: sector number
;cx [bits 6-15]: cylinder
;dh: head
lba_to_chs:
    push ax
    push dx
    
    xor dx, dx
    div word [bdb_sectors_per_track] ;(LBA % sectors per track) + 1 <- sector
    inc dx  ;Sector
    mov cx, dx

    xor dx, dx
    div word [bdb_heads]

    mov dh, dl  ;head
    mov ch, al
    shl ah, 6
    or cl, ah  ;cylinder

    pop ax
    mov dl, al
    pop ax

    ret

disk_read:
    push ax
    push bx
    push cx
    push dx
    push di

    call lba_to_chs

    mov ah, 02h
    mov di, 3  ;counter

retry:
    stc
    int 13h
    jnc doneRead

    call diskReset

    dec di
    test di, di
    jnz retry

failDiskRead:
    mov si, read_failure
    call print
    hlt
    jmp halt

diskReset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc failDiskRead
    popa
    ret

doneRead:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    ret

print:
    push si
    push ax
    push bx

print_loop:
    lodsb
    or al, al
    jz done_print

    mov ah, 0x0e
    mov bh, 0
    int 0x10

    jmp print_loop

done_print:
    pop bx
    pop ax
    pop si
    ret

os_boot_msg: db 'Looding...', 0x0d, 0x0a, 0
read_failure db 'Failed to read disk!', 0x0d, 0x0a, 0
file_kernel_bin db 'KERNEL  BIN'
msg_kernel_not_found db 'KERNEL.BIN not found!'
kernel_cluster dw 0

kernel_load_segment EQU 0x2000
kernel_load_offset EQU 0

TIMES 510-($-$$) db 0
dw 0AA55h

buffer:
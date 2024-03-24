ORG 0x7c00
BITS 16

jmp short main
nop

bdb_oem:  db  'MSWIN4.1'
bdb_bytes_per_sector:  dw  512
bdb_sectors_per_cluster:  db  1
bdb_reserved_sectors:  dw  1
dbd_fat_count:  db  2
bdb_dir_entries_count:  dw 0e0h
bdb_total_sectors:  dw  2880
bdb_media_descriptor_type:  db  0f0h
bdb_sectors_per_fat:  dw  9
bdb_sectors_per_track:  dw  18
bdb_heads:  dw  2
bdb_hidden_sectors:  dd  0
bdb_large_sector_count:  dd  0

ebr_drive_number:  db  0
                    db 0
ebr_signature:  db  29h
ebr_volume_id:  db  12h, 34h, 56h, 78h
ebr_volume_label:  db  'JAZZ OS    '
ebr_system_id:  db  'FAT12   '

main:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    
    mov sp, 0x7c00
    mov si, os_boot_msg
    call print
    hlt

halt:
    jmp halt

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

os_boot_msg: db 'Our os has booted!', 0x0d, 0x0a, 0


TIMES 510-($-$$) db 0
dw 0AA55h
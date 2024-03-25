ORG 0x0
BITS 16

start:
    mov si,os_boot_msg
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
    or al,al
    jz done_print

    mov ah, 0x0E
    mov bh, 0
    int 0x10

    jmp print_loop

done_print:
    pop bx
    pop ax
    pop si
    ret

os_boot_msg: db 'Our OS has booted!!!', 0x0D, 0x0A, 0
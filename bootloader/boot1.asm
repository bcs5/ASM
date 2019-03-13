jmp 0x7c0:main
data:
  msg db "boot 1...", 0
putchar:
  mov ah, 0x0e
  int 10h
  ret
  
endl:
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret
    
prints:             ; mov si, string
  .loop:
    lodsb           ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret

delay1s:                 ; 1 SEC DELAY
  mov cx, 0fh
  mov dx, 4240h
  mov ah, 86h
  int 15h
  ret

delay100ms:              ; 0.1 SEC DELAY
  mov cx, 01h
  mov dx, 86a0h
  mov ah, 86h
  int 15h
  ret

main:
  mov ax, 0x7c0
  mov ds, ax
  mov es, ax
  mov si, msg
  call prints
  call endl
  call delay1s
set_es:
  mov ax, 0x50        ; (0x50*16) = 0x500
  mov es, ax
  jmp reset
reset:                ; INT 13h AH=00h: Reset Disk Drive
  mov ah, 00h
  mov dl, 0           ; Drive
  int 13h
  jc reset            ; if failed, try again
  jmp load
load:                 ; INT 13h AH=02h: Read Sectors From Drive
  mov ah, 02h
  mov al, 34          ; Sectors To Read Count
  mov ch, 0           ; Cylinder
  mov cl, 2           ; Sector
  mov dh, 0           ; Head
  mov dl, 0           ; Drive
  xor bx, bx          ; posição = (es*16)+bx, es:bx Buffer Address Pointer
  int 13h
  jc load             ; if failed, try again
  jmp 0x50:0x0        ; jump to 0x500
times 510-($-$$) db 0
dw 0xaa55

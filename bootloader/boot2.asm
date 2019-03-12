jmp 0x50:main
data:
  msg db "boot 2...", 0
; calls
putchar:
  mov ah, 0x0e
  int 10h
  ret
  
getchar:
  mov ah, 0x00
  int 16h
  ret
  
delchar:
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
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

main:
  mov ax, 0x50
  mov ds, ax
  mov es, ax
  mov si, msg
  call prints
  call endl
  
set_es:
  mov ax, 0x7e0       ; (0x7e*16) = 0x7e0
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
  mov al, 63          ; Sectors To Read Count
  mov ch, 0           ; Cylinder
  mov cl, 18          ; Sector
  mov dh, 1           ; Head
  mov dl, 0           ; Drive
  xor bx, bx          ; posição = (es*16)+bx, es:bx Buffer Address Pointer
  int 13h
  jc load             ; if failed, try again
  jmp 0x7e0:0x0       ; jump to 0x7e0
jmp $
times 34*512-($-$$) db 0

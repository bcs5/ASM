jmp 0x50:main
data:
  str1 db 'Loading structures for the kernel',0
  str2 db 'Setting up protected mode', 0
  str3 db 'Loading kernel in memory', 0
  str4 db 'Running kernel', 0
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
  
print_dots:           ; mov cx, number of dots
  for:
    mov al, '.'
    call putchar
    push cx
    call delay100ms
    call delay100ms
    pop cx
    loop for
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

clear:                    ; mov bl, color
  ; Set the cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10

  ; print 2000 blanck chars to clean  
  mov cx, 2000 
  mov bh, 0
  mov al, 0x20 ; blank char
  mov ah, 0x9
  int 0x10
  
  ; reset cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10
  ret

main:
  mov ax, 0x50
  mov ds, ax
  mov es, ax
  
  mov bl, 10 ; Seta cor dos caracteres para verde
  call clear
  
  mov si, str1
  call prints
  mov cx, 4
  call print_dots
  call endl
  
  mov si, str2
  call prints
  mov cx, 4
  call print_dots
  call endl
  
  mov si, str3
  call prints
  mov cx, 4
  call print_dots
  call endl
  
  mov si, str4
  call prints
  mov cx, 4
  call print_dots
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

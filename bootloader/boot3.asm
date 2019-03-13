jmp 0x7e0:main
data:
  msg db "boot 3...", 0
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
  mov ax, 0x7e0
  mov ds, ax
  mov es, ax
  
  mov bl, 12 ; Seta cor dos caracteres para verde
  call clear
  
  mov si, msg
  call prints
  call endl
  jmp $
times 63*512-($-$$) db 0

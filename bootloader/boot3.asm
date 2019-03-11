jmp 0x7e0:main
data:
  string times 62*512 db 0
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

;  var al, *si;
;  lodsb(){
;    al = *si;
;    si++;
;  }

;    var al, *di;
;    stosb(){
;        *di = al;
;        di++;
;    }

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
  mov ax, 0x7e0
  mov ds, ax
  mov si, msg
  call prints
  call endl
  jmp $
times 63*512-($-$$) db 0

org 0x7c00
jmp 0x0000:main
data:
  string times 11 db 0
  A dw 10000, 5000, 2000, 1000, 500, 200, 100, 50, 25, 10, 5, 1

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
gets:                   ; mov di, string
  xor cx, cx            ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 10        ; string limit checker
    je .loop1
    
    stosb
    inc cl
    call putchar
    
    jmp .loop1
    .backspace:
      cmp cl, 0      ; is empty?
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call delchar
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
  ret

main:
  mov di, string
  call gets
  mov si, string
  xor cx, cx
  xor ax, ax
  .loop1:
    push ax
    lodsb
    mov cl, al
    pop ax
    cmp cl, 0          ; check EOF(NULL)
    je .endloop1
    cmp cl, ','
    je .loop1
    sub cl, 48        ; '9'-'0' = 9
    mov bx, 10
    mul bx            ; 999*10 = 9990
    add ax, cx        ; 9990+9 = 9999
    jmp .loop1
  .endloop1:
  
  mov cx, 12
  mov bx, A
  .loop2:
    push cx
    
    xor dx, dx
    mov cx, word[bx]
    div cx
    
    add al, 48
    call putchar
    call endl
    
    xchg ax, dx
    add bx, 2
    
    pop cx
  loop .loop2
end:
times 510-($-$$) db 0
dw 0xaa55

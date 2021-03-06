; b^e | 0 <= (b, e) <= 9
org 0x7c00
jmp 0x0000:main
data:
  string times 11 db 0
  lower times 11 db 0
  upper times 11 db 0
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

prints:              ; mov si, string
  .loop:
    lodsb          ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret
reverse:            ; mov si, string
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:            ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:           ; remover string da stack        
    pop ax
    stosb
    loop .loop2
  ret
tostring:            ; mov ax, int / mov di, string
  push di
  .loop1:
    cmp ax, 0
    je .endloop1
    xor dx, dx
    mov bx, 10
    div bx          ; ax = 9999 -> ax = 999, dx = 9
    xchg ax, dx        ; swap ax, dx
    add ax, 48        ; 9 + '0' = '9'
    stosb
    xchg ax, dx
    jmp .loop1
  .endloop1:
  pop si
  cmp si, di
  jne .done
  mov al, 48
  stosb
  .done:
    mov al, 0
    stosb
    call reverse
    ret
gets:              ; mov di, string
  xor cx, cx          ; zerar contador
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
stoi:              ; mov si, string
  xor cx, cx
  xor ax, ax
  .loop1:
    push ax
    lodsb
    mov cl, al
    pop ax
    cmp cl, 0        ; check EOF(NULL)
    je .endloop1
    sub cl, 48        ; '9'-'0' = 9
    mov bx, 10
    mul bx          ; 999*10 = 9990
    add ax, cx        ; 9990+9 = 9999
    jmp .loop1
  .endloop1:
  ret
main:
  xor ax, ax
  mov ds, ax
  mov es, ax  
  
  mov di, string
  call gets

  mov si, string
  call stoi
  push ax       ; save base

  mov di, string
  call gets

  mov si, string
  call stoi
  push ax       ; save expoent

  mov ax, 1
  pop cx        ; get expoent
  pop bx        ; get base

  
  cmp cx, 0
  je .endexp
  ; b^e = b^(e-5) * (b^5), evitar overflow
  ; exemplo : 9^9 = 9^(9-5) * 9^(5) = 6561 * 59049, ambos os fatores menores que 2 ^ 16
  .loop1:
    cmp cx, 5
    jle .endloop1
    mul bx
    dec cx
    jmp .loop1
  .endloop1:
  push ax
  mov ax, 1
  .loop2:
    mul bx
  loop .loop2
  pop bx
  mul bx          ; obter b^e, fazendo a multiplicacao de b^(e-5) * (b^5)
  .endexp:

  mov bx, 10000
  div bx              ; separar o numero em duas partes, a lower contém os 4 digitos menos significativos
  
  cmp ax, 0           ; verificar se existe upper
  xchg ax, dx         ; ax = lower, dx = upper
  je .no_upper
  .with_upper:
    xchg ax, dx
    push dx
    
    ; printar upper
    mov di, upper
    call tostring
    mov si, upper
    call prints
    
    ; printar lower
    pop ax
    mov cx, 4         
    .loop3:
      xor dx, dx
      mov bx, 10
      div bx
      xchg ax, dx
      add al, 48
      push ax
      xchg ax, dx
    loop .loop3
    
    mov cx, 4
    .loop4:
      pop ax
      call putchar
    loop .loop4
    call endl
    jmp end
  .no_upper:
    ; printar lower, caso não haja upper
    mov di, lower
    call tostring
    mov si, lower
    call prints
    call endl
end:
times 510-($-$$) db 0
dw 0xaa55

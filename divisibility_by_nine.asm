; Crie um programa que receba como entrada um número N (N < 10^100) e que,
; após a tecla “enter” ser pressionada, seu programa deverá
; informar se o número N digitado é divisível por 9 ou não (basta imprimir “Sim” ou “Não”).

org 0x7c00
jmp 0x0000:main

data:
	string times 101 db 0
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
	mov al, 0x08					; backspace
	call putchar
	mov al, ' '
	call putchar
	mov al, 0x08					; backspace
	call putchar
	ret
endl:
	mov al, 0x0a					; line feed
	call putchar
	mov al, 0x0d					; carriage return
	call putchar
	ret

;	var al, *si;
;	lodsb(){
;		al = *si;
;		si++;
;	}

;    var al, *di;
;    stosb(){
;        *di = al;
;        di++;
;    }

prints:							; mov si, string
	.loop:
		lodsb					; bota character em al 
		cmp al, 0
		je .endloop
		call putchar
		jmp .loop
	.endloop:
	ret
reverse:						; mov si, string
	mov di, si
	xor cx, cx					; zerar contador
	.loop1:						; botar string na stack
		lodsb
		cmp al, 0
		je .endloop1
		inc cl
		push ax
		jmp .loop1
	.endloop1:
	.loop2:						; remover string da stack
		cmp cl, 0
		je .endloop2
		dec cl
		pop ax
		stosb
		jmp .loop2
	.endloop2:
	ret
tostring:						; mov ax, int / mov di, string
	push di
	.loop1:
		cmp ax, 0
		je .endloop1
		xor dx, dx
		mov bx, 10
		div bx					; ax = 9999 -> ax = 999, dx = 9
		xchg ax, dx				; swap ax, dx
		add ax, 48				; 9 + '0' = '9'
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
gets:							; mov di, string
	xor cx, cx					; zerar contador
	.loop1:
		call getchar
		cmp al, 0x08				; backspace
		je .backspace
		cmp al, 0x0d				; carriage return
		je .done
		cmp cl, 100				; string limit checker
		je .loop1
		
		stosb
		inc cl
		call putchar
		
		jmp .loop1
		.backspace:
			cmp cl, 0			; is empty?
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
stoi:							; mov si, string
	xor cx, cx
	xor ax, ax
	.loop1:
		push ax
		lodsb
		mov cl, al
		pop ax
		cmp cl, 0				; check EOF(NULL)
		je .endloop1
		sub cl, 48				; '9'-'0' = 9
		mov bx, 10
		mul bx					; 999*10 = 9990
		add ax, cx				; 9990+9 = 9999
		jmp .loop1
	.endloop1:
	ret
	
; number theory
mod:							; mov ax, num / mov bx, mod
	xor dx, dx
	div bx
	xchg ax, dx
	ret
main:
	xor ax, ax
	mov ds, ax
	mov es, ax
	
	mov di, string
	call gets
	
	mov si, string
	call reverse
	
	mov si, string
	mov cx, 1		; 10^n
	xor ax, ax
	.loop1:
		push ax
		
		lodsb
		
		cmp al, 0
		je .endloop1
		
		; prev + (digit * 10^n)
		xor ah, ah
		sub al, 48		; '9' - '0' = 9
		mul cx			; digit * 10^n
		
		pop bx		
		add ax, bx
		
		mov bx, 9
		call mod		; ax mod bx
		
		push ax			; store result
		
		
		; (10^(n+1)) mod 9
		mov ax, cx
		mov bx, 10
		mul bx
		mov bx, 9
		call mod
		
		mov cx, ax
		pop ax			; restore result
		jmp .loop1
	.endloop1:
	pop ax				; restore result
	mov di, string
	call tostring		; convert number mod 9 to string
	mov si, string
	call prints			; print number mod 9
	
times 510-($-$$) db 0
dw 0xaa55


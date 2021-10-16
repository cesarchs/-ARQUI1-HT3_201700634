imprimir_reg macro reg	;imprimir registros	
    push dx ;bkup de dx	
	push ax
	push cx
	push bx
    mov ah, 02h  
    mov dl, reg   ;asigno a dx el reg 16 bits 
            ;add dx,30h  ;sumamos para q salga el numero tal cual porq en consola +-30h
    int 21h
        ;call XOR_REG    ;reset de registros a,b,c,d
    pop bx
	pop cx
	pop ax 
	pop dx ;bkup de dx	
endm

print macro buffer ;imprime cadena
    push ax
    push dx
        mov ax, @data
        mov ds,ax
        mov ah,09h ;Numero de funcion para imprimir buffer en pantalla
        mov dx,offset buffer ;equivalente a que lea dx,buffer, inicializa en dx la posicion donde comienza la cadena
        int 21h
    pop dx
    pop ax
endm

close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h
endm


imprimirVideo macro caracter, color
	mov ah, 09h
	mov al, caracter ;al guarda el valor que vamos a escribir
	mov bh, 0
	mov bl, color ; valor binario rojo
	mov cx,1
	int 10h
endm

posicionarCursor macro x,y
	mov ah,02h
	mov dh,x
	mov dl,y
	mov bh,0
	int 10h
endm

escribirChar macro char
		mov ah, 02h
		mov dl, char
		int 21h
endm


IntToString macro num, number ; ax 1111 1111 1111 1111 -> 65535
LOCAL Inicio,Final,Mientras,MientrasN,Cero,InicioN
	push si
	push di
	limpiar number,15,24h
	mov ax,num ; ax = numero entero a convertir 23
	cmp ax,0 
	je Cero
	xor di,di
	xor si,si
	jmp Inicio

	;ax = 123

	Inicio:
		
		cmp ax,0 ;ax = 0
		je Mientras
		mov dx,0 
		mov cx,10 
		div cx ; 1/10 = ax = 0 dx = 2
		mov bx,dx 
		add bx,30h ; 1 + 48 = ascii 
		push bx 
		inc di	; di = 3
		jmp Inicio

	Mientras:
		;si = 0 , di = 3
		cmp si,di 
		je Final
		pop bx 
		mov number[si],bl 
		inc si 
		;si = 2 di = 3
		jmp Mientras

	Cero:
	mov number[0],30h
	jmp Final

	Final:
	pop di
	pop si


endm

limpiar macro buffer, numbytes, caracter
LOCAL Repetir
	push si
	push cx

		xor si,si
		xor cx,cx
		mov	cx,numbytes
		;si = 0
		Repetir:
			mov buffer[si], caracter
			inc si ; si ++
			Loop Repetir
	pop cx
	pop si
endm


mensage macro x
   mov ah,06h
   mov dl,x
   int 21h
endm
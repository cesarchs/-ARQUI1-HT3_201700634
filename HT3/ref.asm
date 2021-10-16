imprimir macro buffer ;imprime cadena
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


escribirChar macro char
		mov ah, 02h
		mov dl, char
		int 21h
endm

posicionarCursor macro x,y
	mov ah,02h
	mov dh,x
	mov dl,y
	mov bh,0
	int 10h
endm

imprimirVideo macro caracter, color
	mov ah, 09h
	mov al, caracter ;al guarda el valor que vamos a escribir
	mov bh, 0
	mov bl, color ; valor binario rojo
	mov cx,1
	int 10h
endm

esDiptongo macro caracter1, caracter2 ;en el registor al va a tener un 1 si es un diptongo o un 0 si no lo es
LOCAL salida, esA, esE, esO, esDip
mov al,0



esA:
	cmp caracter1,97 ;97 es a
	jne esE

	cmp caracter2,105
	je esDip

	cmp caracter2, 117
	je esDip

	jmp salida
	

esE:

	cmp caracter1,101 ;97 es a
	jne esO

	cmp caracter2,105
	je esDip

	cmp caracter2, 117
	je esDip

	jmp salida


esO:

	cmp caracter1,111 ;97 es a
	jne salida

	cmp caracter2,105
	je esDip

	cmp caracter2, 117
	je esDip

	jmp salida

esDip:
	mov al,1


jmp salida


salida: 

endm

.model small

;----------------SEGMENTO DE PILA---------------------
.stack

;----------------SEGMENTO DE DATO---------------------

.data

saltoLinea db 0Ah,0Dh,"$"
saludo db 0Ah,0Dh, "Anlaizando texto..........","$"
fin db 0Ah,0Dh, "Finalizando el programa.......", "$"


texto db "Hola esto es un peine y una aula","$"

fila db 0
columna db 0

;----------------SEGMENTO DE CODIGO---------------------


.code
main proc

; se inicializa modo video con una resolucion de 80x25
mov ah, 0
mov al, 03h
int 10h

imprimir saludo
imprimir saltoLinea

mov ah, 03h
mov bh, 00h
int 10h ;dh guarda el valor de la ultima posicion fila y dl guarda la ultima posicion de la columna

mov fila, dh
mov columna, dl
mov si, 0
mov di, 0

ciclo1:
	;posicionar al cursor donde corresponde
	posicionarCursor fila, columna

	esDiptongo texto[si], texto[si+1]

	cmp al,0  
	je letra

	;pintamos el diptongo
	imprimirVideo texto[si], 0100b ;imprimos blanco
	inc columna ;aumenta la posicion del cursor
	inc si

	posicionarCursor fila, columna

	
	imprimirVideo texto[si], 0100b ;imprimos blanco
	jmp siguiente

	letra:
		imprimirVideo texto[si], 1111b ;imprimos blanco
		jmp siguiente


	siguiente:

	inc columna ;aumenta la posicion del cursor
	inc si



	cmp columna, 80d
	jl noSalto
		mov columna,0
		inc fila
	noSalto:

	cmp texto[si], 36d 
	jne ciclo1

	inc fila
	mov ah,02h
	mov dh,fila
	mov dl,0
	mov bh,0
	int 10h
	
cerrar:

mov ah, 4ch ;Numero de funcion que finaliza el programa
xor al,al
int 21h

main endp
end main	


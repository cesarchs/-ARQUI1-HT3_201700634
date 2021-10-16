include macrosre.asm ;archivo con los macros a utilizar

.model small

.stack

.data
seconds db 0  ; variable para comparar los segunos en el delay

P_reloj db 'RELOJ - 201700634','$'

printGion db ' - ','$'

contadorVer db 15, '$'

salida2 db 15,'$'
; ANIO-------------
dia db 0
mes db 0
anio dw 0
;----------------
; HORA----------
hour db 0
minute db 0
second db 0
;----------------
auxPrint1 db 0
auxPrint2 db 0


.code
delay proc  
	delaying:   
	;GET SYSTEM TIME.
	mov  ah, 2ch
	int  21h      	  ; RETURN SECONDS IN DH.
					  ;CHECK IF ONE SECOND HAS PASSED. 
	cmp  dh, seconds  ; IF SECONDS ARE THE SAME...
	je   delaying     ;...WE ARE STILL IN THE SAME SECONDS.
	mov  seconds, dh  ; SECONDS CHANGED. PRESERVE NEW SECONDS.
	ret
delay endp  
main proc

	mov ax,@data
	mov ds,ax

ciclo:
;HACE QUE SE RESCRIBA -------------------------------------------
	; se inicializa modo video con una resolucion de 40*25
	;256 colores, 320*200 pixels, 1 pagina
	mov ah, 0
	mov al, 13h
	int 10h

	posicionarCursor 10,11 
;----------------------------------------------------------------
	print P_reloj

	posicionarCursor 12,9 ; posicionando en el centro de la pantalla 
	; colocando 12 (eje y) como valores mas cercanos al centro exacto en funcion del tamaño de la pantalla
	; y en 9 (eje x) como valor mas cercano al centro exacto en funcion del texto que presentamos
	; siendo 21 caracteres los que imprimimos en pantalla.
	; el calculo para el eje x seria de la siguiente manera ((40-21)/2) = 9.5 -> usamos 9 

	;TRAEMOS LA FECHA DEL SISTEMA
	mov ah,2Ah 
	int 21h

	;movemos los valores resultantes de fecha a variables
	mov dia,dl
	mov mes,dh
	mov anio,cx

	;-----------------------------------------------


	mov al,dia   		;cl obtiene la hora y se transiere a al
	aam      	 		;ax se convierte a BCD
	
	add al,'0'   		;convertimos AL en ASCII
	mov auxPrint2,al    ;movemos la parte baja de AX a n2
	add ah,'0'   		;convertimos AH en ASCII
	mov auxPrint1,ah    ;movemos la parte alta de AX a n1
	
	mensage auxPrint1
	mensage auxPrint2
	mensage  '/'

	;----------------------------------------------
	; MES
	mov al,mes
	aam          		;ax se convierte a BCD
	
	add al,'0'   		;convertimos AL en ASCII
	mov auxPrint2,al    ;movemos la parte baja de AX a n2
	add ah,'0'   		;convertimos AH en ASCII
	mov auxPrint1,ah    ;movemos la parte alta de AX a n1

	mensage auxPrint1
	mensage auxPrint2
	mensage '/'
	;--------------------------------------------------
	; AñO

	IntToString cx, contadorVer ; convertimos el numero del año a string para poder imprimirlo en pantalla
	print contadorVer			; imprimimos el numero en pantalla

	
	print printGion				; imprimimos el guion y espacios para separar la fecha de la hora 

	;---------------------------------------------------

	;HORA

	MOV AH, 2CH
	INT 21H

	;movemos los valores resultantes de la hora del sistemas a variables
	mov hour ,ch
	mov minute, cl
	mov second,dh

	;----------------------------------------------
	;hora
	mov al,hour
	aam      			;ax se convierte a BCD
	
	add al,'0'   		;convertimos AL en ASCII
	mov auxPrint2,al   	;movemos la parte baja de AX a n2
	add ah,'0'   		;convertimos AH en ASCII
	mov auxPrint1,ah   	;movemos la parte alta de AX a n1

	mensage auxPrint1
	mensage auxPrint2
	mensage ':'

	;----------------------------------------------
	;----------------------------------------------
	;minutos
	mov al,minute
	aam      			;ax se convierte a BCD
	
	add al,'0'   		;convertimos AL en ASCII
	mov auxPrint2,al   	;movemos la parte baja de AX a n2
	add ah,'0'   		;convertimos AH en ASCII
	mov auxPrint1,ah   	;movemos la parte alta de AX a n1

	mensage auxPrint1
	mensage auxPrint2
	mensage ':'

	;----------------------------------------------
	;second
	mov al,second
	aam      			;ax se convierte a BCD
	
	add al,'0'   		;convertimos AL en ASCII
	mov auxPrint2,al   	;movemos la parte baja de AX a n2
	add ah,'0'   		;convertimos AH en ASCII
	mov auxPrint1,ah   	;movemos la parte alta de AX a n1

	mensage auxPrint1
	mensage auxPrint2



call delay
jmp ciclo

	;----------------------------------------------

	close
main endp

end main